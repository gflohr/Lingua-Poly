#! /bin/false
#
# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018-2019 Guido Flohr <guido.flohr@cantanea.com>
#               All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package Lingua::Poly::RestAPI::Logger;

use strict;

use Mojolicious;
use Mojo::Base 'Mojo::Log';

sub realm { 'general' }

sub debug {
	my ($self, @args) = @_;

	my $level = $self->app->log->level;

	return $self if $level ne 'debug';

	my $debug = $ENV{LINGUA_POLY_DEBUG} // 'all';
	my %debug = map { lc $_ => 1 } split /[ \t:,\|]/, $debug;
	my $realm = $self->realm;

	if ($debug{all} || $debug{$realm}) {
		foreach my $arg (@args) {
			$arg = "[$realm] $arg";
		}
	} else {
		return $self;
	}

	return $self->app->log->debug(@args);
}

sub info {
	my ($self, @args) = @_;

	return $self->app->log->info(@args);
}

sub fatal {
	my ($self, @args) = @_;

	return $self->app->log->fatal(@args);
}

1;
