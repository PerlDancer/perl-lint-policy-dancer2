#!/usr/bin/perl

use strict;
use warnings;
use lib 'lib';
use Perl::Lint;

my @target_files = @ARGV or die "$0 <FILES>\n";

my $linter     = Perl::Lint->new({ filter => ['Dancer2'] });
my $violations = $linter->lint(\@target_files);

foreach my $file (@target_files) {
    my @file_violations = grep +( $_->{'filename'} eq $file ), @{$violations};
    foreach my $violation (@file_violations) {
        printf "$file [%d]: %s\n", @{$violation}{qw<line description>};
    }
}

use DDP;
p $violations;
