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
	my ($url, %options) = @_;

	my $canonical = eval { $checker->check($url) };
	return if $@;

	return $canonical;
};

ok $check->('http://my.example.com'), 'http okay';
ok $check->('https://my.example.com', 'https okay');
ok !$check->('gopher://my.example.com'), 'gopher not okay';
ok !$check->('/path/to/resource'), 'schemeless not okay';

is $check->('http://www.example.com.'), 'http://www.example.com/',
	'trailing dot';
is $check->('http://WWW.exaMple.COM'), 'http://www.example.com/',
	'to lowercase';
is $check->('http://www.example.com:80'), 'http://www.example.com/',
	'default port';

ok !$check->('http://localhost'), 'localhost';
ok !$check->('http://whatever'), 'non-fqdn';
ok !$check->('http://what..ever.com'), 'consecutive dots';
ok !$check->('http://what.ever.com..'), 'two trailing dots';

done_testing;
