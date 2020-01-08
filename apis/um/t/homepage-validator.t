#! /usr/bin/env perl

# Copyright (C) 2018 Guido Flohr <guido.flohr@cantanea.com>,
# all rights reserved.

# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

use strict;

use Test::More;

use Lingua::Poly::API::UM::Validator::Homepage;

my $checker = Lingua::Poly::API::UM::Validator::Homepage->new;

ok $checker;

my $check = sub {
	my ($url) = @_;

	my $canonical = eval { $checker->check($url) };
	return if $@;

	return $canonical;
};

ok !$check->('http://my_example.fr'), 'forbidden character';

ok $check->('http://my.example.fr'), 'http okay';
ok $check->('https://my.example.fr', 'https okay');
ok !$check->('gopher://my.example.fr'), 'gopher not okay';
ok !$check->('/path/to/resource'), 'schemeless not okay';

ok !$check->('http://www.example.fr:65536'), 'port out of range';
ok !$check->('http://www.example.fr:0'), 'port zero';
ok !$check->('http://www.example.fr:-80'), 'negative port';
ok $check->('http://www.example.fr:1234', 'valid port');

is $check->('http://www.example.fr.'), 'http://www.example.fr/',
	'trailing dot';
is $check->('http://WWW.exaMple.FR'), 'http://www.example.fr/',
	'to lowercase';
is $check->('http://www.example.fr:80'), 'http://www.example.fr/',
	'default port';

ok !$check->('http://localhost'), 'localhost';
ok !$check->('http://whatever'), 'non-fqdn';
ok !$check->('http://what..ever.com'), 'consecutive dots';
ok !$check->('http://what.ever.com..'), 'two trailing dots';

ok !$check->('http://4.3.2.1.in-addr.arpa'), '.in-addr.arpa';
ok !$check->('http://www.example.int'), '.int';

ok $check->('http://www.пример.bg'), 'utf-8 domain name';

# RFC2606
ok !$check->('http://www.test'), 'RFC2606 .test';
ok !$check->('http://www.example'), 'RFC2606 .example';
ok !$check->('http://www.localhost'), 'RFC2606 .localhost';
ok !$check->('http://www.invalid'), 'RFC2606 .invalid';
ok !$check->('http://www.example.com'), 'RFC2606 .example.com';
ok !$check->('http://www.example.net'), 'RFC2606 .example.net';
ok !$check->('http://www.example.org'), 'RFC2606 .example.org';

done_testing;
