# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018 Guido Flohr <guido.flohr@cantanea.com>
#               All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package Lingua::Poly::FI::Word::Verb::Type1;

use strict;
use utf8;

use Locale::TextDomain qw(Lingua-Poly);

use base qw(Lingua::Poly::FI::Word::Verb);

sub inflect {
    my ($self, $person, $numerus, %options) = @_;
 
    $self->SUPER::_preInflect($person, $numerus, %options);

    my $stem = substr $$self, 0, -1;
    if ($person != 3) {
        my %gradations1 = (
            kk => 'k',
            pp => 'p',
            tt => 't',
            '(?<=[aeiouäöyAEIOUÄÖY])k' => '',
            p => 'v',
            t => 'd',
            nt => 'nn',
            rt => 'rr',
            KK => 'K',
            PP => 'P',
            TT => 'T',
            K => '',
            P => 'V',
            T => 'D',
            NT => 'NN',
            RT => 'RR',
        );
        my $gradations1 =  join '|', keys %gradations1;
        my %gradations2 = (
            lke => 'lje',
            rke => 'rje',
            LKE => 'LJE',
            RKE => 'RJE',
        );
        my $gradations2 =  join '|', keys %gradations2;

        if ($stem !~ s/($gradations2)$/$gradations2{$1}/) {
            $stem !~ s/($gradations1)(.)$/$gradations1{$1}$2/;
        }
    }

    if ($person == 1 && $numerus == 2) {
        my $regular = $self->_ending($stem, $person, $numerus);
        my $coll =  $stem;
        if ($stem =~ /[aou]/i) {
            $coll = $stem . 'taan';
        } else {
            $coll = $stem . 'tään';
        }
        return [$regular, $coll];
    }

    return $self->_ending($stem, $person, $numerus);
}

1;

=head1 NAME

Lingua::Poly::FI::Word::Verb::Type1

=head1 SYNOPSIS

=head1 COPYRIGHT

Copyright (C) 2018 Guido Flohr  <guido.flohr@cantanea.com>, all rights
reserved.

This library is free software. It comes without any warranty, to
the extent permitted by applicable law. You can redistribute it
and/or modify it under the terms of the Do What the Fuck You Want
to Public License, Version 2, as published by Sam Hocevar. See
http://www.wtfpl.net/ for more details.

=head1 SEE ALSO

perl(1)
