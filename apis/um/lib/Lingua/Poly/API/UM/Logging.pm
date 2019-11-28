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

package Lingua::Poly::API::UM::Logging;

use strict;

sub realm { 'general' }

sub logContext {
	my $realm = shift->realm;
	return "[$realm]";
}

sub logger {
	shift->{_logger};
}

sub debug {
	my ($self, @messages) = @_;

	$self->logger->debug($self->realm,  @messages);
}

sub info {
	my ($self, @messages) = @_;

	$self->logger->info(@messages);
}

sub warn {
	my ($self, @messages) = @_;

	$self->logger->warn(@messages);
}

sub error {
	my ($self, @messages) = @_;

	$self->logger->error(@messages);
}

sub fatal {
	my ($self, @messages) = @_;

	$self->logger->fatal(@messages);
}

1;
