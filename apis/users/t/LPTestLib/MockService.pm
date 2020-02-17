#! /bin/false
#
# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018-2019 Guido Flohr <guido.flohr@Lingua::Poly::API.com>
#			   All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package LPTestLib::MockService;

use strict;

use List::Util 1.29 qw(pairs);

sub new {
	my ($class) = @_;

	bless {
		__mockedCalls => [],
		__mockedReturns => {},
		__mockedMethods => {},
	}, $class;
}

sub isa { 1 }

sub mockAll {
	my ($self) = @_;

	$self->{__mockAll} = 1;

	return $self;
}

sub mockReturn {
	my ($self, $name, @values) = @_;

	$self->{__mockedReturns}->{$name} ||= [];
	push @{$self->{__mockedReturns}->{$name}}, [@values];

	return $self;
}

sub mockMethod {
	my ($self, $name, $sub) = @_;

	$sub ||= sub { shift };

	$self->{__mockedMethods}->{$name} = $sub;

	return $self;
}

sub mockedCalls {
	my ($self, @names) = @_;

	return @{$self->{__mockedCalls}} if !@names;

	my @calls;
	my %names = map { $_ => 1 } @names;

	foreach my $pair (pairs @{$self->{__mockedCalls}}) {
		my ($name, $args) = @$pair;

		push @calls, $name, $args if $names{$name};
	}

	return @calls;
}

sub AUTOLOAD {
	my ($self, @args) = @_;

	our $AUTOLOAD;
	my $class = ref $self;
	my $method = $AUTOLOAD;
	$method =~ s/^${class}:://;

	push @{$self->{__mockedCalls}}, $method, [@args];

	if ($self->{__mockedReturns}->{$method}) {
		if (!@{$self->{__mockedReturns}->{$method}}) {
			require Carp;
			Carp::confess("return stack for '$method' exceeded");
		}
		my $values = shift @{$self->{__mockedReturns}->{$method}};
		if (!@$values) {
			return;
		} elsif (@$values == 1) {
			return $values->[0];
		} else {
			return @$values;
		}
	} elsif ($self->{__mockedMethods}->{$method}) {
		return $self->{__mockedMethods}->{$method}->($self, @args);
	} if ($self->{__mockAll}) {
		return $self;
	} elsif ('DESTROY' eq $method) {
		return;
	}

	require Carp;
	Carp::confess("method '$method' is not defined and not being mocked");
}

1;

=head1 NAME

LPTestLib::MockService - Mocked service with canned behavior

=head1 SYNOPSIS

    $logger = LPTestLib::MockService->new;
	$logger->mockAll;
    $logger->info('whatever');
    $logger->debug('blah blah');

    $service = LPTestLib::MockService->new;
    $service->mockReturn(sequence => 1);
    $service->mockReturn(sequence => 4);
    $service->mockReturn(sequence => 9);
    $service->sequence;    # Returns 1.
    $service->sequence;    # Returns 4.
    $service->sequence;    # Returns 9.

    @calls = $service->mockedCalls;

    $service->isa('Foo::Bar');  # Returns true.

=head1 DESCRIPTION

Instances of B<LPTestLib::MockService> are blessed Perl objects with a canned
behavior.  They can mock arbitrary methods returning either canned values, or
you can mock the methods with subroutines you pass in.

These objects consider themselves to be everything, so that you calling
B<isa()> on them will always return true.

You can also make these objects inherit from other classes.

=head1 METHODS

=over 4

=item B<new>

The constructor takes no arguments.

=item B<mockReturn NAME[, VALUES...]>

Pushes B<VALUES> on the return stack for method B<NAME>.  If B<NAME()> is
called on the object, it will shift the values from that stack and return them.

If no values were passed, false is returned from the corresponding call.

If exactly one value was passed, that value is returned.

If multiple values have been passed, they are returned as a list.  You have to
pay attention that the caller expects a list at that point!

If the return stack was exceeded, and exception is thrown.

=item B<mockMethod NAME, SUB>

Mocks method B<NAME()> with the subroutine B<SUB>.  That subroutine should have
the behavior of a method, i. e. it should expect the instance or the class name
as its first argument.

If you have ever called B<mockReturn()> for B<NAME>, the call to
B<mockMethod()> for this method has no effect because canned return values
have precedence over canned behaviors.

If you omit B<SUB>, the method will just return the instance (resp. class).
That means that mocked methods can be chained by default.

=item B<inherit SUPERCLASS, ...>

Adds B<SUPERCLASS> as a class to inherit method calls from.

If neither a canned return value or a method mock was defined, the mock service
checks whether one of the superclasses defines the method.

=item B<mockedCalls [NAMES...]>

Returns all calls that have been mocked by the class as pairs.  The first
element of each pair is the method name, the second one is an array reference
to the arguments that had been passed.  You can iterate over these values
with B<pairs()> from L<List::Util>.

Contrary to what the name suggests, this includes calls to inherited methods.

If you pass method B<NAMES>, only calls to these methods are returned.

Remember that the method returns a list!  If it returns a number, you have
not called it in list context.

=back

=head1 SEE ALSO

L<UNIVERSAL>, L<List::Util>, L<perl>
