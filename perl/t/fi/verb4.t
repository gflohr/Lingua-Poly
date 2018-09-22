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

$word = Lingua::Poly::FI::Word::Verb->new('haluta');
is $word->inflect(1, 1), 'haluan';
is $word->inflect(2, 1), 'haluat';
is $word->inflect(3, 1), 'haluaa';
is $word->inflect(1, 2)->[0], 'haluamme';
is $word->inflect(1, 2)->[1], 'halutaan';
is $word->inflect(2, 2), 'haluatte';
is $word->inflect(3, 2), 'haluavat';

done_testing;
