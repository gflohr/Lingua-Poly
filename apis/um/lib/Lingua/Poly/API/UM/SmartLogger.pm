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

package Lingua::Poly::API::UM::SmartLogger;

use strict;

use Mojo::Base qw(Mojo::Log);

sub debug {
	my ($self, $realm, @args) = @_;

	my $level = $self->level;

	return $self if $level ne 'debug';

	my $debug = $ENV{LINGUA_POLY_DEBUG} // 'all';
	my %debug = map { lc $_ => 1 } split /[ \t:,\|]/, $debug;

	return $self if !($debug{all} || $debug{$realm});

	return $self->SUPER::debug(@args);
}

1;
