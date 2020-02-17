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

use List::Util '1.29';

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

sub AUTOLOAD {
	my ($self, @args) = @_;

	our $AUTOLOAD;
	my $class = ref $self;
	my $method = $AUTOLOAD;
	$method =~ s/^${class}:://;

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
		push @{$self->{__mockedCalls}, $AUTOLOAD, [@args]};
		return $self;
	} elsif ('DESTROY' eq $method) {
		return;
	}

	require Carp;
	Carp::confess("method '$method' is not defined and not being mocked");
}

1;
