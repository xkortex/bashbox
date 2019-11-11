#!/usr/bin/perl
use strict;
use warnings;
use 5;

# This tool is designed to be a generic nested datastructure parser that can handle any
# jq-compatible data and process it with jq
# If the data is json, pass it straight to jq.



sub jq_on_string {
    # Run jq on a string passed to this function
    # First argument is the string
    # Second argument is args passed to jq

    my $exit_code = system("echo '$_[0]' | jq $_[1]");
    exit($exit_code >> 8);
    # The value returned from system() is an integer which encodes the exit value of
    # the child process plus flags indicating how the child process exited
}

sub yq_on_string {
    # Run jq on a string passed to this function via yq
    # First argument is the string
    # Second argument is args passed to yq then jq

    my $exit_code = system("echo '$_[0]' | yq read -j - | jq $_[1]");
    exit($exit_code >> 8);
}
sub yq_on_file {
    # Run jq on a string passed to this function via yq
    # First argument is the filename
    # Second argument is args passed to yq then jq

    my $exit_code = system("yq read -j $_[0] | jq $_[1]");
    exit($exit_code >> 8);
}

if (-t STDIN) {
    # we're running from a shell, without input being piped to us. send file right to processor
    my $filename = $ARGV[-1]; # todo: combine with pop operation
    my ($ext) = $filename =~ /(\.[^.]+)$/;

    # handle basic json query and exit early
    if ($ext eq '.json') {
        my @cmd = @ARGV;
        unshift(@cmd, "jq");

        my $exit_code = system(@cmd);
        exit($exit_code >> 8);
    }

    pop(@ARGV);
    my $argstr = join(" ", @ARGV);
    yq_on_file($filename, $argstr);

} else {
    ## leaving some breadcrumbs for future self:
    #    print "[pipe]\n";
    my $stdin = join("", <STDIN>);
    my $argstr = join(" ", @ARGV);
    #	print "[$stdin]";
    #	print "---___---\n";
    # Can't really infer from a file stream easily, so just throw yq at it
    # This is still quite performant, runs a query in about 20 ms
    yq_on_string($stdin, $argstr);
    # my $exit_code = system("echo '$stdin' | jq @ARGV");

}


