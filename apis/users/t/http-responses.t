#! /usr/bin/env perl

# Copyright (C) 2018 Guido Flohr <guido.flohr@cantanea.com>,
# all rights reserved.

# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

use strict;

use lib 't';

use Test::More;
use JSON;
use HTTP::Status qw(:constants status_message);

use LPTestLib::HTTP::ResponseFactory;

my @data = (Tom => 'foo', Dick => 'bar', Harry => 'baz');

my $gen = LPTestLib::HTTP::ResponseFactory->new;
my $json = JSON->new->utf8;

my $r;

my $scalar = 'scalar';
eval { $gen->json(\$scalar) };
ok $@;

$r = $gen->json({@data});
is_deeply $json->decode($r->decoded_content), {@data};
is $r->code, scalar HTTP_OK, 'status code';
is $r->status_line, HTTP_OK . ' ' . status_message HTTP_OK;
is $r->content_type, 'application/json', 'content-type';
is $r->content_charset, 'UTF-8', 'content-charset';

$r = $gen->json([@data]);
is_deeply $json->decode($r->decoded_content), [@data];

my $payload = bless {@data}, 'What::Ever';
$r = $gen->json($payload);
is_deeply $json->decode($r->decoded_content), {@data};

done_testing;
