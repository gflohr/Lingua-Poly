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

package Lingua::Poly::API::Users::Service::RequestContext;

use strict;

use Moose;
use namespace::autoclean;
use Mojo::URL;

use Lingua::Poly::API::Users::Util qw(empty);

use base qw(Lingua::Poly::API::Users::Logging);

has logger => (is => 'ro');
has configuration => (is => 'ro');

sub fingerprint {
	my ($self, $ctx) = @_;

	my $ua = $ctx->req->headers->user_agent();
	$ua //= '';

	my $ip = $ctx->remote_addr;

	return join ':', $ip, $ua;
}

sub sessionID {
	my ($self, $ctx) = @_;

	my $cookie_name = $self->configuration->{session}->{cookieName};

	return $ctx->cookie($cookie_name);
}

sub authToken {
	my ($self, $ctx) = @_;

	my $cookie_name = $self->configuration->{session}->{rememberCookie};

	my $value = $ctx->cookie($cookie_name);
	return if empty $value;

	return $value;
}

sub sessionCookie {
	my ($self, $ctx, $session) = @_;

	my $cookie_name = $self->configuration->{session}->{cookieName};
	if ($session) {
		$ctx->cookie($cookie_name => $session->sid, {
			path => $ctx->config->{prefix},
			httponly => 1,
			secure => $ctx->req->is_secure,
		});
	} else {
		$ctx->cookie($cookie_name => '', { expires => 0 });
	}

	return $self;
}

sub origin {
	my ($self, $ctx) = @_;

	my $origin = $self->configuration->{origin};
	return $origin if !empty $origin;

	my $request_url = $ctx->req->url->to_abs;
	$origin = Mojo::URL->new
		->host($request_url->host)
		->port($request_url->port)
		->scheme($request_url->scheme);

	return $origin;
}

__PACKAGE__->meta->make_immutable;

1;
