package Perl::Lint::Filter::Dancer2;
use strict;
use warnings;
use Module::Pluggable;

# filter() seems to do the opposite of what i want
# instead of picking what should be used, it picks what shouldn't be used
# so i need to find everything that *isn't* what we want *sigh*

sub filter {
    Module::Pluggable->import(
        search_path => 'Perl::Lint::Policy',
        require     => 0,
        inner       => 0,
        except      => [ qw<
            Perl::Lint::Policy::Dancer2::ProhibitObsoleteImport
            Perl::Lint::Policy::Dancer2::ProhibitObsoleteKeywords
            Perl::Lint::Policy::Dancer2::RequireLeadingForwardSlash
            Perl::Lint::Policy::Dancer2::ProhibitMergedParameters
        > ],
    );

    my @site_policies = map s/^Perl::Lint::Policy:://r, plugins(); # Exported by Module::Pluggable
    return \@site_policies;
}

1;
