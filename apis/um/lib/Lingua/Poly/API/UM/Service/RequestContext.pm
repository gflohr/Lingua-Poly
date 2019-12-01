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

package Lingua::Poly::API::UM::Service::RequestContext;

use strict;

use Moose;
use namespace::autoclean;

use base qw(Lingua::Poly::API::UM::Logging);

has logger => (is => 'ro');
has configuration => (is => 'ro');

sub fingerprint {
	my ($self, $ctx) = @_;

	my $ua = $ctx->req->headers->user_agent();
	$ua //= '';

	my $ip = $ctx->remote_addr;

	return join ':', $ip, $ua;
}

sub sessionID  {
	my ($self, $ctx) = @_;

	my $cookie_name = $self->configuration->{session}->{cookieName};

	return $ctx->cookie($cookie_name);
}

__PACKAGE__->meta->make_immutable;

1;
