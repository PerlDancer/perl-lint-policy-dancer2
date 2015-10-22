package Perl::Lint::Policy::Dancer2::ProhibitObsoleteKeywords;
use strict;
use warnings;
use parent 'Perl::Lint::Policy';
use List::Util 'first';
use Perl::Lint::Constants::Type;

use constant {
    DESC => 'Obsolete keywords no longer available',
    EXPL => 'load() and param_array() do not exist in Dancer2 anymore.',
};

sub evaluate {
    my ( $class, $file, $tokens, $src, $args ) = @_;

    my @obs_keywords = qw<load param_array>;
    my @violations;
    for ( my $i = 0; my $token = $tokens->[$i]; $i++ ) {
        $token->{'type'} == KEY
            && first { $token->{'data'} eq $_ } @obs_keywords
            or next;

        push @violations, {
            filename    => $file,
            line        => $token->{'line'},
            description => DESC,
            explanation => EXPL . " (found: $token->{'data'})",
            policy      => __PACKAGE__,
        };
    }

    return \@violations;
}

1;
