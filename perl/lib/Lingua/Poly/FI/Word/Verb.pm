# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018-2019 Guido Flohr <guido.flohr@cantanea.com>
#               All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package Lingua::Poly::FI::Word::Verb;

use strict;
use utf8;

use Locale::TextDomain qw(Lingua-Poly);

use Lingua::Poly::FI::Word::Verb::Type1;
use Lingua::Poly::FI::Word::Verb::Type2;
use Lingua::Poly::FI::Word::Verb::Type3;
use Lingua::Poly::FI::Word::Verb::Type4;

use base qw(Lingua::Poly::Word::Verb Lingua::Poly::FI::Word);

my $vowel = "aeiou\x{e4}\x{f6}yAEIOU\x{c4}\x{d6}Y";

sub new {
    my ($class, $infinitive) = @_;

    my $self =  $class->SUPER::new($infinitive);
    my %exceptions = (
        "n\x{e4}hd\x{e4}"  => 2,
        tehdä  => 2,
    );
    my $type;
    my $lc = lc $$self;
    if (exists $exceptions{$lc}) {
        $type =  $exceptions{$lc};
    } elsif ($lc =~ /[$vowel][a\x{e4}]$/) {
        $type = 1;
    } elsif ($lc =~ /[$vowel][dD][a\x{e4}]$/) {
        $type = 2;
    } elsif ($lc =~ /([lnr])\1[a\x{e4}]$/i || $lc =~ /sta/i) {
        $type = 3;
    } elsif  ($lc =~ /[aou\x{e4}\x{f6}]/) {
        $type = 4;
    } else {
        die  __x("Unrecognized verb '{verb}'!\n", verb => $infinitive);
    }

    $class = "Lingua::Poly::FI::Word::Verb::Type$type";

    bless $self, $class;
}

sub tenses {
     my (undef, $localized) = @_;

     my @tenses = (N__('Present'),
                   N__('Imperfect'),
                   N__('Perfect'),
                   N__('Pluperfect'));
     if ($localized) {
         map { __($_) } @tenses;
     } else {
         return @tenses;
     }
}

sub _ending {
    my ($self, $stem, $person, $numerus) = @_;

    if ($person < 3) {
        return $stem . qw(n t mme tte)[$person + ($numerus << 1) - 3];
    } elsif ($numerus == 1) {
        # Double the vowel.
        $stem =~ s/(.)$/$1$1/ unless $stem =~ /(.)\1$/;
        return $stem;
    } elsif ($stem =~ /[aou]/i) {
        return $stem . 'vat';
    } else  {
        return $stem . 'vät';
    }
}

1;

=head1 NAME

Lingua::Poly::FI::Word::Verb

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
