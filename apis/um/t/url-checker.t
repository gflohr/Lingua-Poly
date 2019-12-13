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

use Lingua::Poly::API::UM::Service::URLChecker;

my $checker = Lingua::Poly::API::UM::Service::URLChecker->new;

ok $checker;

my $check = sub {
	my ($url, %options) = @_;

	eval { $checker->check($url, %options) };
	return if $@;

	return 1;
};

ok $check->('http://my.example.com'), 'http okay';
ok $check->('https://my.example.com', 'https okay');
ok !$check->(
	'http://my.example.com',
	scheme_whitelist => ['https'],
), 'http is not whitelisted';
ok !$check->('gopher://my.example.com'), 'gopher not okay';
ok $check->('gopher://my.example.com', scheme_whitelist => ['gopher']), 'gopher ok';
ok $check->('gopher://my.example.com', scheme_whitelist => ['*']), 'scheme wildcard';

ok !$check->('http://localhost'), 'localhost is not allowed';
ok $check->('http://localhost', host_whitelist => ['localhost'],
	'localhost is whitelisted');
ok $check->('http://www.competitor.com'), 'www.competitor.com';
ok !$check->('http://www.competitor.com',
	host_blacklist => ['www.competitor.com']),
	'www.competitor.com is blacklisted';
ok $check->('http://www.competitor.com',
	host_blacklist => ['competitor.com']),
	'www.competitor.com is not blacklisted';
$DB::single = 1;
ok !$check->('http://www.competitor.com',
	host_blacklist => ['*.competitor.com']),
	'*.competitor.com is blacklisted';

done_testing;
