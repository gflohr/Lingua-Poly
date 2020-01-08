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

ok !$check->('http://www.example.x-y'), 'hyphen in tld';
ok !$check->('http://org.x11', 'digit in tld');
ok $check->('http://www.xn--e1afmkfd'), 'unicode tld';

# Empty or invalid hostnames.
ok !$check->('http://...'), 'triple dot';
ok !$check->('http://..'), 'double dot';
ok !$check->('http://.'), 'single dot';

# IPv4 addresses.
ok $check->('http://1.2.3.4'), 'valid IPv4';
ok !$check->('http://127.0.0.1'), 'loopback';
ok !$check->('http://127.2.3.4'), 'xloopback';
ok !$check->('http://10.23.4.89'), 'private IPv4 10.x.x.x';
ok !$check->('http://172.23.4.89'), 'private IPv4 172.x.x.x';
ok !$check->('http://192.168.169.170'), 'private IPv4 192.168.x.x';
ok !$check->('http://169.254.169.170'), 'link-local IPv4';
ok !$check->('http://100.65.66.67'), 'carrier-grade NAT deployment IPv4';

# IPv4 normalization.
is $check->('http://0x78.00000.0.0000170'), 'http://120.0.0.120/', 'hex/octal IPv4';
is $check->('http://0X00078.00000.0.0000170'), 'http://120.0.0.120/', 'hex/octal IPv4';
# This is *not* an IPv4 address!  It's a fqdn with an invalid top-level domain.
ok !$check->('http://1.2.3.08'), 'invalid IPv4 with octal';

# IPv6 addresses.
$DB::single =  1;
ok $check->('http://[89ab::1234]'), 'valid IPv6';
ok $check->('http://[89ab::1234]/'), 'valid IPv6 with slash';
ok $check->('http://[89ab::1234]/foo/bar'), 'valid IPv6 with path';
ok $check->('http://[89ab::1234]:1234'), 'valid IPv6 with port';
ok $check->('http://[89ab::1234]:1234/'), 'valid IPv6 with port and slash';
ok $check->('http://[89ab::1234]:1234/foo/bar'), 'valid IPv6 with port and path';

# RFC2606
ok !$check->('http://www.test'), 'RFC2606 .test';
ok !$check->('http://www.example'), 'RFC2606 .example';
ok !$check->('http://www.localhost'), 'RFC2606 .localhost';
ok !$check->('http://www.invalid'), 'RFC2606 .invalid';
ok !$check->('http://www.example.com'), 'RFC2606 .example.com';
ok !$check->('http://www.example.net'), 'RFC2606 .example.net';
ok !$check->('http://www.example.org'), 'RFC2606 .example.org';

done_testing;
