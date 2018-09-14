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

use Test::More;
use Lingua::Poly::FI::Word::Verb::Type1;

my $word;

$word = Lingua::Poly::FI::Word::Verb::Type1->new('asua');
is $word->inflect(1, 1), 'asun';
is $word->inflect(2, 1), 'asut';
is $word->inflect(3, 1), 'asuu';
is $word->inflect(1, 2), 'asumme';
is $word->inflect(2, 2), 'asutte';
is $word->inflect(3, 2), 'asuvat';

$word = Lingua::Poly::FI::Word::Verb::Type1->new('nukkua');
is $word->inflect(1, 1), 'nukun';
is $word->inflect(2, 1), 'nukut';
is $word->inflect(3, 1), 'nukkuu';
is $word->inflect(1, 2), 'nukumme';
is $word->inflect(2, 2), 'nukutte';
is $word->inflect(3, 2), 'nukkuvat';

$word = Lingua::Poly::FI::Word::Verb::Type1->new('oppia');
is $word->inflect(1, 1), 'opin';
is $word->inflect(2, 1), 'opit';
is $word->inflect(3, 1), 'oppii';
is $word->inflect(1, 2), 'opimme';
is $word->inflect(2, 2), 'opitte';
is $word->inflect(3, 2), 'oppivat';

done_testing;
