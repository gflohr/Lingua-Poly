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

eval { $service->self };
ok $@;

eval { $service->fortyTwo('whatever') };
ok $@;

eval { $service->echo(qw(Tom Dick Harry))};
ok $@;

$service->mockMethod('self');
$service->mockMethod(echo => sub { shift; return @_ });
$service->mockMethod(fortyTwo => sub { return 42 });

is $service->fortyTwo, 42, 'forty-two';
is_deeply [$service->echo(qw(Tom Dick Harry))], [qw(Tom Dick Harry)];
is_deeply $service->self, $service, 'self';

done_testing;
