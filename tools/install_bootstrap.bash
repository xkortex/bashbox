#!/bin/bash
# Sets up a computer from fresh Ubuntu X.04 install to allow Ansible provisioning

sudo apt update
sudo apt install -y \
    git \
    zsh \
    tmux \
    curl \
    wget \
    htop \
    python \
    python3 \
    openssh-server \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    build-essential \
    pkg-config \
    software-properties-common

# network utilities
NO_NET_UTILS=${NO_NET_UTILS:-}
if [[ -z $NO_NET_UTILS ]]; then
    sudo apt install -y\
        arp-scan \
        dnsutils \
        netdiscover \
        traceroute
fi
