package Perl::Lint::Policy::Dancer2::ProhibitObsoleteImport;
use strict;
use warnings;
use parent 'Perl::Lint::Policy';
use List::Util 'first';
use Perl::Lint::Constants::Type;

use constant {
    DESC => 'Importing Dancer2 with obsolete tags',
    EXPL => 'The tags :syntax, :tests, and :script '
          . 'are now obsolete and no longer necessary.',
};

sub evaluate {
    my ( $class, $file, $tokens, $src, $args ) = @_;

    my @obs_tags = qw<:syntax :tests :script>;
    my @violations;
    my $in_use;
    for ( my $i = 0; my $token = $tokens->[$i]; $i++ ) {
        if (
             $token->{'type'}            == USE_DECL
          && $tokens->[ $i+1 ]->{'type'} == USED_NAME
          && $tokens->[ $i+1 ]->{'data'} eq 'Dancer2'
        ) {
            $i++;
            $in_use = 1;
            next;
        }

        $in_use or next;

        if ( $token->{'type'} == SEMI_COLON ) {
            $in_use = 0;
            next;
        }

        # use Dancer2 ':tag';
        # use Dancer2 ":tag";
        # use Dancer2 ':tag', ':tag';
        # use Dancer2 ':tag' => ':tag';
        if (
            ( $token->{'type'} == RAW_STRING || $token->{'type'} == STRING )
            &&
            ( first { $token->{'data'} eq $_ } @obs_tags )
        ) {
            push @violations, {
                filename    => $file,
                line        => $token->{'line'},
                description => DESC,
                explanation => EXPL . " (found: $token->{'data'})",
                policy      => __PACKAGE__,
            };

            next;
        }

        # use Dancer2 qw( :tag );
        if ( $token->{'type'} == REG_LIST && $token->{'data'} eq 'qw' ) {
            $i += 2;
            my $element_list_str = $tokens->[$i]{'data'};
            $element_list_str =~ s/^\s*//;
            $element_list_str =~ s/\s*$//;
            my @element_list = split /\s+/, $element_list_str;
            foreach my $elem_str (@element_list) {
                first { $elem_str eq $_ } @obs_tags
                    and push @violations, {
                        filename    => $file,
                        line        => $token->{'line'},
                        description => DESC,
                        explanation => EXPL . " (found: $elem_str)",
                        policy      => __PACKAGE__,
                    };
            }
        }
    }

    return \@violations;
}

1;
