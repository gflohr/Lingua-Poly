#! /usr/bin/env perl

# Copyright (C) 2018 Guido Flohr <guido.flohr@cantanea.com>,
# all rights reserved.

# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

use strict;

use Test::More tests => 8;

use Lingua::Poly::API::Users::Util qw(equals);

# Both defined.
ok equals '', '';
ok !equals 'foo', 'bar';
ok equals 'foobar', 'foobar';

# First not defined.
ok equals undef, undef;
ok equals undef, '';
ok !equals undef, 'foobar';

# Second not defined.
ok equals '', undef;
ok !equals 'foobar', undef;
