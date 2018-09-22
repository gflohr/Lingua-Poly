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

$word = Lingua::Poly::FI::Word::Verb->new('pakata');
is $word->inflect(1, 1), 'pakkaan';
is $word->inflect(2, 1), 'pakkaat';
is $word->inflect(3, 1), 'pakkaa';
is $word->inflect(1, 2)->[0], 'pakkaamme';
is $word->inflect(1, 2)->[1], 'pakataan';
is $word->inflect(2, 2), 'pakkaatte';
is $word->inflect(3, 2), 'pakkaavat';

$word = Lingua::Poly::FI::Word::Verb->new('napata');
is $word->inflect(1, 1), 'nappaan';
is $word->inflect(2, 1), 'nappaat';
is $word->inflect(3, 1), 'nappaa';
is $word->inflect(1, 2)->[0], 'nappaamme';
is $word->inflect(1, 2)->[1], 'napataan';
is $word->inflect(2, 2), 'nappaatte';
is $word->inflect(3, 2), 'nappaavat';

$word = Lingua::Poly::FI::Word::Verb->new('mitata');
is $word->inflect(1, 1), 'mittaan';
is $word->inflect(2, 1), 'mittaat';
is $word->inflect(3, 1), 'mittaa';
is $word->inflect(1, 2)->[0], 'mittaamme';
is $word->inflect(1, 2)->[1], 'mitataan';
is $word->inflect(2, 2), 'mittaatte';
is $word->inflect(3, 2), 'mittaavat';

$word = Lingua::Poly::FI::Word::Verb->new('tavata');
is $word->inflect(1, 1), 'tapaan';
is $word->inflect(2, 1), 'tapaat';
is $word->inflect(3, 1), 'tapaa';
is $word->inflect(1, 2)->[0], 'tapaamme';
is $word->inflect(1, 2)->[1], 'tavataan';
is $word->inflect(2, 2), 'tapaatte';
is $word->inflect(3, 2), 'tapaavat';

done_testing;
