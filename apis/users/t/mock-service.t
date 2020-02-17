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

use LPTestLib::MockService;

my $logger = LPTestLib::MockService->new;

ok $logger->isa('Log::Whatever');

$logger->mockAll;

$logger->info('some information');

my $service = LPTestLib::MockService->new;

eval { $service->undefined('whatever') };
ok $@;

done_testing;
