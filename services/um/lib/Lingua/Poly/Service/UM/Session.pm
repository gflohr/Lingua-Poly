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

package Lingua::Poly::Service::UM::Session;

use strict;

use Mojolicious;
use Mojo::Base 'Lingua::Poly::Service::UM::Logging';

use Lingua::Poly::Service::UM::Util qw(empty);

my $logger;

sub new {
	my ($class, %args) = @_;

	$logger = $args{context}->app->logger->context('[session]')
	    if !defined $logger;

	my $ctx = $args{context};
	my $self = bless {
		_ctx => $ctx,
		_logger => $logger,
	}, $class;

	$self->debug("initializing");

	my $config = $ctx->config;
	my $db = $ctx->stash->{db};

	my $cookie_name = $config->{session}->{cookieName};

	# Check if cookie exists.
	my $session_id = $ctx->cookie($cookie_name);
	my $user;
	if (!empty $session_id) {

	}

	my $random = $ctx->random_string(entropy => 256);
	$ctx->cookie(id => $random, {
		path => $ctx->config->{path},
		httponly => 1,
		secure => $ctx->req->is_secure,
	});

	return $self;
}

sub app {
	my ($self) = @_;

	return $self->{_ctx}->app;
}
1;
