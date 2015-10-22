package Perl::Lint::Policy::Dancer2::ProhibitMergedParameters;
use strict;
use warnings;
use parent 'Perl::Lint::Policy';
use List::Util 'first';
use Perl::Lint::Constants::Type;

use constant {
    DESC => 'Always provide parameters source when fetching parameters',
    EXPL => 'params() and param() should provide an argument for the '
          . 'parameters source instead of using the default merged values.',
};

sub evaluate {
    my ( $class, $file, $tokens, $src, $args ) = @_;

    my @param_keywords = qw<param params>;
    my @violations;
    for ( my $i = 0; my $token = $tokens->[$i]; $i++ ) {
        $token->{'type'} == KEY
            && first { $token->{'data'} eq $_ } @param_keywords
            or next;

        # param()
        # params()
        # params->
        # param->
        if ( $tokens->[$i+1]{'type'} != LEFT_PAREN ) {
            push @violations, {
                filename    => $file,
                line        => $token->{'line'},
                description => DESC,
                explanation => EXPL . " (found: $token->{'data'})",
                policy      => __PACKAGE__,
            };

            next;
        }

        $i += 2;
        $token = $tokens->[$i];

        if ( $token->{'type'} != STRING && $token->{'type'} != RAW_STRING ) {
            push @violations, {
                filename    => $file,
                line        => $token->{'line'},
                description => DESC,
                explanation => EXPL . " (found: $token->{'data'})",
                policy      => __PACKAGE__,
            };
        }
    }

    return \@violations;
}

1;
