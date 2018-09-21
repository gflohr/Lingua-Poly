# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018 Guido Flohr <guido.flohr@cantanea.com>
#               All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

use strict;

use utf8;
use Test::More;
use Lingua::Poly::FI::Word::Verb;

my $word;

$word = Lingua::Poly::FI::Word::Verb->new('asua');
is $word->inflect(1, 1), 'asun';
is $word->inflect(2, 1), 'asut';
is $word->inflect(3, 1), 'asuu';
is $word->inflect(1, 2)->[0], 'asumme';
is $word->inflect(1, 2)->[1], 'asutaan';
is $word->inflect(2, 2), 'asutte';
is $word->inflect(3, 2), 'asuvat';

$word = Lingua::Poly::FI::Word::Verb->new('nukkua');
is $word->inflect(1, 1), 'nukun';
is $word->inflect(2, 1), 'nukut';
is $word->inflect(3, 1), 'nukkuu';
is $word->inflect(1, 2)->[0], 'nukumme';
is $word->inflect(1, 2)->[1], 'nukutaan';
is $word->inflect(2, 2), 'nukutte';
is $word->inflect(3, 2), 'nukkuvat';

$word = Lingua::Poly::FI::Word::Verb->new('oppia');
is $word->inflect(1, 1), 'opin';
is $word->inflect(2, 1), 'opit';
is $word->inflect(3, 1), 'oppii';
is $word->inflect(1, 2)->[0], 'opimme';
is $word->inflect(1, 2)->[1], 'opitaan';
is $word->inflect(2, 2), 'opitte';
is $word->inflect(3, 2), 'oppivat';

$word = Lingua::Poly::FI::Word::Verb->new('ottaa');
is $word->inflect(1, 1), 'otan';
is $word->inflect(2, 1), 'otat';
is $word->inflect(3, 1), 'ottaa';
is $word->inflect(1, 2)->[0], 'otamme';
is $word->inflect(1, 2)->[1], 'otataan';
is $word->inflect(2, 2), 'otatte';
is $word->inflect(3, 2), 'ottavat';

$word = Lingua::Poly::FI::Word::Verb->new('lukea');
is $word->inflect(1, 1), 'luen';
is $word->inflect(2, 1), 'luet';
is $word->inflect(3, 1), 'lukee';
is $word->inflect(1, 2)->[0], 'luemme';
is $word->inflect(1, 2)->[1], 'luetaan';
is $word->inflect(2, 2), 'luette';
is $word->inflect(3, 2), 'lukevat';

# But not here!
$word = Lingua::Poly::FI::Word::Verb->new('itkeä');
is $word->inflect(1, 1), 'itken';
is $word->inflect(2, 1), 'itket';
is $word->inflect(3, 1), 'itkee';
is $word->inflect(1, 2)->[0], 'itkemme';
is $word->inflect(1, 2)->[1], 'itketään';
is $word->inflect(2, 2), 'itkette';
is $word->inflect(3, 2), 'itkevät';

$word = Lingua::Poly::FI::Word::Verb->new('kylpeä');
is $word->inflect(1, 1), 'kylven';
is $word->inflect(2, 1), 'kylvet';
is $word->inflect(3, 1), 'kylpee';
is $word->inflect(1, 2)->[0], 'kylvemme';
is $word->inflect(1, 2)->[1], 'kylvetään';
is $word->inflect(2, 2), 'kylvette';
is $word->inflect(3, 2), 'kylpevät';

$word = Lingua::Poly::FI::Word::Verb->new('pitää');
is $word->inflect(1, 1), 'pidän';
is $word->inflect(2, 1), 'pidät';
is $word->inflect(3, 1), 'pitää';
is $word->inflect(1, 2)->[0], 'pidämme';
is $word->inflect(1, 2)->[1], 'pidätään';
is $word->inflect(2, 2), 'pidätte';
is $word->inflect(3, 2), 'pitävät';

$word = Lingua::Poly::FI::Word::Verb->new('antaa');
is $word->inflect(1, 1), 'annan';
is $word->inflect(2, 1), 'annat';
is $word->inflect(3, 1), 'antaa';
is $word->inflect(1, 2)->[0], 'annamme';
is $word->inflect(1, 2)->[1], 'annataan';
is $word->inflect(2, 2), 'annatte';
is $word->inflect(3, 2), 'antavat';

$word = Lingua::Poly::FI::Word::Verb->new('kertoa');
is $word->inflect(1, 1), 'kerron';
is $word->inflect(2, 1), 'kerrot';
is $word->inflect(3, 1), 'kertoo';
is $word->inflect(1, 2)->[0], 'kerromme';
is $word->inflect(1, 2)->[1], 'kerrotaan';
is $word->inflect(2, 2), 'kerrotte';
is $word->inflect(3, 2), 'kertovat';

$word = Lingua::Poly::FI::Word::Verb->new('kulkea');
is $word->inflect(1, 1), 'kuljen';
is $word->inflect(2, 1), 'kuljet';
is $word->inflect(3, 1), 'kulkee';
is $word->inflect(1, 2)->[0], 'kuljemme';
is $word->inflect(1, 2)->[1], 'kuljetaan';
is $word->inflect(2, 2), 'kuljette';
is $word->inflect(3, 2), 'kulkevat';

$word = Lingua::Poly::FI::Word::Verb->new('särkeä');
is $word->inflect(1, 1), 'särjen';
is $word->inflect(2, 1), 'särjet';
is $word->inflect(3, 1), 'särkee';
is $word->inflect(1, 2)->[0], 'särjemme';
is $word->inflect(1, 2)->[1], 'särjetään';
is $word->inflect(2, 2), 'särjette';
is $word->inflect(3, 2), 'särkevät';

done_testing;
