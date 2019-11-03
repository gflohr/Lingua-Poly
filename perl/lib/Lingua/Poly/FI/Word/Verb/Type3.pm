# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018-2019 Guido Flohr <guido.flohr@cantanea.com>
#               All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package Lingua::Poly::FI::Word::Verb::Type3;

use strict;
use utf8;

use Locale::TextDomain qw(Lingua-Poly);

use base qw(Lingua::Poly::FI::Word::Verb);

my $vowel = "aeiou\x{e4}\x{f6}yAEIOU\x{c4}\x{d6}Y";

sub inflect {
    my ($self, $person, $numerus, %options) = @_;

    my $stem = substr $$self, 0, -2;
    # Gradation type 2 for verbs ending in -lla and -llä, when they have 3
    # syllables or more.
    # FIXME! This is mostly guesswork!
    if ($stem !~ /vella$/i
        && $stem =~ s/([$vowel]+)([^$vowel]+)([$vowel]+)l$/$1/) {
        my ($consonants, $vowels) = map { lc } ($2, $3);
        my %gradations = (
            k => 'kk',
            p => 'pp',
            t => 'tt',
            d => 't',
            mm => 'mp',
            ll =>  'lt',
            nn => 'nt',
            rr => 'rt',
        );
        $consonants = $gradations{$consonants} || $consonants;

        $stem .= $consonants . $vowels . 'l';
    } elsif ($stem =~ s/([^$vowel])([$vowel])([$vowel])l$/$1/) {
        my ($vowel1, $vowel2) = ($2, $3);
        my $lc = lc "$vowel1$vowel2";

        my %diphtongs = map { $_ => 1}
                        ("ai", "au", "\x{e4}y", "oi", "ou", "ei", "eu",
                         "\x{f6}i", "\x{f6}y", "ui", "uo", "iu", "iy", "ie",
                         "yi", "y\x{f6}");

        if (!$diphtongs{$lc} && $vowel1 ne $vowel2) {
            $vowel1 .= 'k';
        }
        $stem .= $vowel1 . $vowel2 . 'l';
    }

    $stem .= 'e';

    if ($person == 1 && $numerus == 2) {
        my $regular = $self->_ending($stem, $person, $numerus);
        my $coll =  $$self;
        $coll =~ s/(.)$/$1$1n/;
        return [$regular, $coll];
    } elsif ($$self =~ /^olla$/ && $person == 3) {
        if ($numerus == 1) {
            return  'on';
        } else  {
            $stem = 'o';
        }
    }

    return $self->_ending($stem, $person, $numerus);
}

1;

=head1 NAME

Lingua::Poly::FI::Word::Verb::Type2;

=head1 SYNOPSIS

=head1 COPYRIGHT

Copyright (C) 2018-2019 Guido Flohr  <guido.flohr@cantanea.com>, all rights
reserved.

This library is free software. It comes without any warranty, to
the extent permitted by applicable law. You can redistribute it
and/or modify it under the terms of the Do What the Fuck You Want
to Public License, Version 2, as published by Sam Hocevar. See
http://www.wtfpl.net/ for more details.

=head1 SEE ALSO

perl(1)
