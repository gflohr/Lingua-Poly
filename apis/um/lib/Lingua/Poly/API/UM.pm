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

package Lingua::Poly::API::UM;

use strict;

use Mojo::Base ('Mojolicious', 'Lingua::Poly::API::UM::Logging');

use Time::HiRes qw(gettimeofday);
use YAML;
use HTTP::Status qw(:constants);
use Locale::TextDomain qw(Lingua-Poly-API-UM);
use Locale::Messages qw(turn_utf_8_off);
use CGI::Cookie;

# Help cpanm to find dependencies.
use Mojolicious::Plugin::Util::RandomString 0.08;
use Mojolicious::Plugin::RemoteAddr 0.03;

use Lingua::Poly::API::UM::Util qw(empty);
use Lingua::Poly::API::UM::Session;

use Moose;

has 'configuration' => (is => 'ro');
has 'database' => (is => 'ro');
has 'logger' => (is => 'rw');
has 'userService' => (is => 'ro');
has 'sessionService' => (is => 'ro');

my $last_cleanup = 0;

sub realm { 'core' };

sub startup {
	my ($self) = @_;

	$self->logger($self->log->context($self->logContext));

	$self->moniker('lingua-poly-service-um');

	$self->plugin('Util::RandomString');
	$self->plugin('RemoteAddr');

	$self->config($self->configuration);

	$self->plugin(OpenAPI => {
		spec => $self->static->file('openapi.yaml')->path,
		schema => 'v3',
		security => {
			cookieAuth => sub {
				my ($c, $definition, $scopes, $cb) = @_;

				# TODO! Check that session exists and has a valid user.

				return $c->$cb;
			}
		}
	});

	my $config = $self->config;
	$self->hook(before_dispatch => sub {
		my ($c) = @_;

		my $now = time;
		if ($now != $last_cleanup) {
			$last_cleanup = $now;
			$self->database->transaction(
				[ DELETE_USER_STALE => $config->{session}->{timeout} ],
				[ DELETE_SESSION_STALE => $config->{session}->{timeout} ],
				[ DELETE_TOKEN_STALE => $config->{session}->{timeout} ],
			);
		}

		$self->userService->doSomething;

		# TODO! Make sure to re-use existing sessions!
		$c->stash->{session} = Lingua::Poly::API::UM::Session->new(context => $c);
	});

}

1;
