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

$word = Lingua::Poly::FI::Word::Verb->new('luulla');
is $word->inflect(1, 1), 'luulen';
is $word->inflect(2, 1), 'luulet';
is $word->inflect(3, 1), 'luulee';
is $word->inflect(1, 2)->[0], 'luulemme';
is $word->inflect(1, 2)->[1], 'luullaan';
is $word->inflect(2, 2), 'luulette';
is $word->inflect(3, 2), 'luulevat';

$word = Lingua::Poly::FI::Word::Verb->new('panna');
is $word->inflect(1, 1), 'panen';
is $word->inflect(2, 1), 'panet';
is $word->inflect(3, 1), 'panee';
is $word->inflect(1, 2)->[0], 'panemme';
is $word->inflect(1, 2)->[1], 'pannaan';
is $word->inflect(2, 2), 'panette';
is $word->inflect(3, 2), 'panevat';

$word = Lingua::Poly::FI::Word::Verb->new('purra');
is $word->inflect(1, 1), 'puren';
is $word->inflect(2, 1), 'puret';
is $word->inflect(3, 1), 'puree';
is $word->inflect(1, 2)->[0], 'puremme';
is $word->inflect(1, 2)->[1], 'purraan';
is $word->inflect(2, 2), 'purette';
is $word->inflect(3, 2), 'purevat';

$word = Lingua::Poly::FI::Word::Verb->new('nousta');
is $word->inflect(1, 1), 'nousen';
is $word->inflect(2, 1), 'nouset';
is $word->inflect(3, 1), 'nousee';
is $word->inflect(1, 2)->[0], 'nousemme';
is $word->inflect(1, 2)->[1], 'noustaan';
is $word->inflect(2, 2), 'nousette';
is $word->inflect(3, 2), 'nousevat';

$word = Lingua::Poly::FI::Word::Verb->new('olla');
is $word->inflect(1, 1), 'olen';
is $word->inflect(2, 1), 'olet';
is $word->inflect(3, 1), 'on';
is $word->inflect(1, 2)->[0], 'olemme';
is $word->inflect(1, 2)->[1], 'ollaan';
is $word->inflect(2, 2), 'olette';
is $word->inflect(3, 2), 'ovat';

$word = Lingua::Poly::FI::Word::Verb->new('ajatella');
is $word->inflect(1, 1), 'ajattelen';
is $word->inflect(2, 1), 'ajattelet';
is $word->inflect(3, 1), 'ajattelee';
is $word->inflect(1, 2)->[0], 'ajattelemme';
is $word->inflect(1, 2)->[1], 'ajatellaan';
is $word->inflect(2, 2), 'ajattelette';
is $word->inflect(3, 2), 'ajattelevat';

$word = Lingua::Poly::FI::Word::Verb->new('nakella');
is $word->inflect(1, 1), 'nakkelen';
is $word->inflect(2, 1), 'nakkelet';
is $word->inflect(3, 1), 'nakkelee';
is $word->inflect(1, 2)->[0], 'nakkelemme';
is $word->inflect(1, 2)->[1], 'nakellaan';
is $word->inflect(2, 2), 'nakkelette';
is $word->inflect(3, 2), 'nakkelevat';

$word = Lingua::Poly::FI::Word::Verb->new('tapella');
is $word->inflect(1, 1), 'tappelen';
is $word->inflect(2, 1), 'tappelet';
is $word->inflect(3, 1), 'tappelee';
is $word->inflect(1, 2)->[0], 'tappelemme';
is $word->inflect(1, 2)->[1], 'tapellaan';
is $word->inflect(2, 2), 'tappelette';
is $word->inflect(3, 2), 'tappelevat';

$word = Lingua::Poly::FI::Word::Verb->new('jaella');
is $word->inflect(1, 1), 'jakelen';
is $word->inflect(2, 1), 'jakelet';
is $word->inflect(3, 1), 'jakelee';
is $word->inflect(1, 2)->[0], 'jakelemme';
is $word->inflect(1, 2)->[1], 'jaellaan';
is $word->inflect(2, 2), 'jakelette';
is $word->inflect(3, 2), 'jakelevat';

$word = Lingua::Poly::FI::Word::Verb->new('suudella');
is $word->inflect(1, 1), 'suutelen';
is $word->inflect(2, 1), 'suutelet';
is $word->inflect(3, 1), 'suutelee';
is $word->inflect(1, 2)->[0], 'suutelemme';
is $word->inflect(1, 2)->[1], 'suudellaan';
is $word->inflect(2, 2), 'suutelette';
is $word->inflect(3, 2), 'suutelevat';

$word = Lingua::Poly::FI::Word::Verb->new('ommella');
is $word->inflect(1, 1), 'ompelen';
is $word->inflect(2, 1), 'ompelet';
is $word->inflect(3, 1), 'ompelee';
is $word->inflect(1, 2)->[0], 'ompelemme';
is $word->inflect(1, 2)->[1], 'ommellaan';
is $word->inflect(2, 2), 'ompelette';
is $word->inflect(3, 2), 'ompelevat';

$word = Lingua::Poly::FI::Word::Verb->new('puhallella');
is $word->inflect(1, 1), 'puhaltelen';
is $word->inflect(2, 1), 'puhaltelet';
is $word->inflect(3, 1), 'puhaltelee';
is $word->inflect(1, 2)->[0], 'puhaltelemme';
is $word->inflect(1, 2)->[1], 'puhallellaan';
is $word->inflect(2, 2), 'puhaltelette';
is $word->inflect(3, 2), 'puhaltelevat';

$word = Lingua::Poly::FI::Word::Verb->new('kuunnella');
is $word->inflect(1, 1), 'kuuntelen';
is $word->inflect(2, 1), 'kuuntelet';
is $word->inflect(3, 1), 'kuuntelee';
is $word->inflect(1, 2)->[0], 'kuuntelemme';
is $word->inflect(1, 2)->[1], 'kuunnellaan';
is $word->inflect(2, 2), 'kuuntelette';
is $word->inflect(3, 2), 'kuuntelevat';

$word = Lingua::Poly::FI::Word::Verb->new('imarrella');
is $word->inflect(1, 1), 'imartelen';
is $word->inflect(2, 1), 'imartelet';
is $word->inflect(3, 1), 'imartelee';
is $word->inflect(1, 2)->[0], 'imartelemme';
is $word->inflect(1, 2)->[1], 'imarrellaan';
is $word->inflect(2, 2), 'imartelette';
is $word->inflect(3, 2), 'imartelevat';

done_testing;
