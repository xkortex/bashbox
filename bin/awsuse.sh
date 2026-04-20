FZF_DEFAULT_OPTS="--reverse --height=100%"

awsuse() {
  local profiles selected profile_choice profile

  # Cleanup option
  if [[ "$1" == "--cleanup" ]]; then
    echo "🧹 Cleaning up AWS CLI and SSO cache..."

    rm -rf ~/.aws/cli/cache/*
    rm -rf ~/.aws/sso/cache/*

    echo "✅ Cache cleaned: ~/.aws/cli/cache/ and ~/.aws/sso/cache/"
    return 0
  fi

  # Build profile list with numbering
  profiles=$(
    {
      printf "%-4s %-20s %-20s %-25s %-25s\n" "NO." "PROFILE" "ACCOUNT_ID" "ROLE_NAME" "AWS_ACCOUNT_NAME"
      printf "%-4s %-20s %-20s %-28s %-25s\n" "----" "--------------------" "--------------------" "--------------------------" "-----------------------------"

      awk -v i=1 '
        BEGIN { FS=" *= *" }
        /^\[profile / {
          if (profile) {
            printf("%-4d %-20s %-20s %-45s %-25s\n", count++, profile, account, role, name)
          }
          gsub(/\[profile |]/, "", $0)
          profile=$0
          account=""; role=""; name=""; count=i++
          next
        }
        /sso_account_id/ { account=$2 }
        /sso_role_name/ { role=$2 }
        /sso_account_name/ { name=$2 }
        END {
          if (profile) {
            printf("%-4d %-20s %-20s %-45s %-25s\n", count, profile, account, role, name)
          }
        }
      ' ~/.aws/config
    }
  )

  # Show FZF with number selection prompt
  selected=$(echo "$profiles" | fzf --header-lines=2 --layout=default --prompt="🔍 Select AWS profile or type number > " --ansi --expect=enter)

  # Capture the actual profile name if selected
  profile=$(echo "$selected" | tail -n +2 | awk '{print $2}' | xargs)

  if [ -z "$profile" ]; then
    echo "❌ No profile selected. Current AWS_PROFILE is $AWS_PROFILE"
    return 1
  fi

  export AWS_PROFILE="$profile"
  echo "✅ Switched to AWS_PROFILE=$AWS_PROFILE"

  if ! aws sts get-caller-identity --profile "$AWS_PROFILE" > /dev/null 2>&1; then
    echo "🔐 Not authenticated. Running SSO login for profile: $AWS_PROFILE"
    aws sso login --profile "$AWS_PROFILE"
  fi

  local identity_json account role_arn role acct_name
  identity_json=$(aws sts get-caller-identity --output json --profile "$AWS_PROFILE")
  account=$(echo "$identity_json" | jq -r .Account)
  role_arn=$(echo "$identity_json" | jq -r .Arn)
  role=$(echo "$role_arn" | awk -F'/' '{print $2}')

  acct_name=$(aws organizations describe-account \
    --account-id "$account" \
    --query "Account.Name" \
    --output text \
    --profile "$AWS_PROFILE" 2>/dev/null)

  if [ $? -eq 0 ] && [ -n "$acct_name" ]; then
    echo "✅ Authenticated to account: $account ($acct_name) with role: $role"
  else
    echo "✅ Authenticated to account: $account with role: $role"
  fi
}
