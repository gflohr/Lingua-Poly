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

package Lingua::Poly::RestAPI::Session;

use strict;

use Mojolicious;
use Mojo::Base 'Lingua::Poly::RestAPI::Logger';

sub realm { 'session' }

sub new {
	my ($class, $c) = @_;

	my $self = bless {
		__ctx => $c,
	}, $class;

	$self->debug("initializing");

	my $cookie = $c->cookie('id');

	my $random = $c->random_string(entropy => 256);
	$c->cookie(id => $random, {
		path => $c->config->{path},
		httponly => 1,
		secure => $c->req->is_secure,
	});

	return $self;
}

sub app {
	my ($self) = @_;

	return $self->{__ctx}->app;
}
1;
