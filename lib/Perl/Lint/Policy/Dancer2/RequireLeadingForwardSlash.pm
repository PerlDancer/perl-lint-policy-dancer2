package Perl::Lint::Policy::Dancer2::RequireLeadingForwardSlash;
use strict;
use warnings;
use parent 'Perl::Lint::Policy';
use List::Util 'first';
use Perl::Lint::Constants::Type;

use constant {
    DESC => 'Route definitions must begin with a slash',
    EXPL => 'Dancer2 requires all routes begin with a forward slash.',
};

sub evaluate {
    my ( $class, $file, $tokens, $src, $args ) = @_;

    my @methods = qw<get head post put del options>;
    my @violations;
    for ( my $i = 0; my $token = $tokens->[$i]; $i++ ) {
        $token->{'type'} == KEY
            && first { $token->{'data'} eq $_ } @methods
            or next;

        $token = $tokens->[++$i];

        # handle get(...)
        $token->{'type'} == LEFT_PAREN
            and $token = $tokens->[++$i];

        # ignoring regex
        $token->{'type'} == REG_DECL
            and next;

        $token->{'type'} == STRING || $token->{'type'} == RAW_STRING
            or die sprintf "Cannot understand code at line %d: %s\n",
                           @{$token}{qw<line data>};

        $token->{'data'} =~ /^\//
            or push @violations, {
                filename    => $file,
                line        => $token->{'line'},
                description => DESC,
                explanation => EXPL . " (found: $token->{'data'})",
                policy      => __PACKAGE__,
            };

        # TODO: any
    }

    return \@violations;
}

1;
