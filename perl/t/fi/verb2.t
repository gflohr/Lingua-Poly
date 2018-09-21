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

$word = Lingua::Poly::FI::Word::Verb->new('saada');
is $word->inflect(1, 1), 'saan';
is $word->inflect(2, 1), 'saat';
is $word->inflect(3, 1), 'saa';
is $word->inflect(1, 2), 'saamme';
is $word->inflect(2, 2), 'saatte';
is $word->inflect(3, 2), 'saavat';

$word = Lingua::Poly::FI::Word::Verb->new('nähdä');
is $word->inflect(1, 1), 'näen';
is $word->inflect(2, 1), 'näet';
is $word->inflect(3, 1), 'näkee';
is $word->inflect(1, 2), 'näemme';
is $word->inflect(2, 2), 'näette';
is $word->inflect(3, 2), 'näkevät';

done_testing;
