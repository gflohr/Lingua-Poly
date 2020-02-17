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

my $retval = $logger->info('some information');

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

eval { $service->double(1 .. 5) };
ok $@;

foreach my $num (1 .. 5) {
	$service->mockReturn(double => $num << 1);
}

foreach my $num (1 .. 5) {
	is $service->double($num), $num << 1, "double $num";
}
eval { $service->double(2304) };
ok $@, 'return stack exceeded';

my $memory = LPTestLib::MockService->new
	->mockAll
	->once(1)
	->twice(2)
	->twice(3);

is_deeply [$memory->mockedCalls], [
	once => [1],
	twice => [2],
	twice => [3],
], 'all mocked calls';

is_deeply [$memory->mockedCalls('once', 'twice')], [
	once => [1],
	twice => [2],
	twice => [3],
], 'both mocked calls';

is_deeply [$memory->mockedCalls('once')], [
	once => [1],
], 'once mocked calls';

is_deeply [$memory->mockedCalls('twice')], [
	twice => [2],
	twice => [3],
], 'twice mocked calls';

my $inherited = LPTestLib::MockService->new;
$inherited->inherit(RealService => name => 'foobar');

is $inherited->realMethod('works'), 'works', 'inherited method';
eval { $inherited->inherit(RealService => name => 'barbaz') };
ok $@, 'inherit must be called only once';

is_deeply [$inherited->mockedCalls], [
	realMethod => ['works'],
];

done_testing;

package RealService;

sub new {
	my ($class, @args) = @_;

	die if $args[0] ne 'name';
	die if $args[1] ne 'foobar';

	bless {@args}, $class;
}

sub realMethod {
	my ($self, $arg) = @_;

	return $arg;
}
