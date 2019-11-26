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

package Lingua::Poly::RestAPI;

use strict;

use Mojo::Base ('Mojolicious', 'Lingua::Poly::RestAPI::Logger');

sub realm { 'core' }

use Time::HiRes qw(gettimeofday);
use YAML;
use Plack::Request;
use Plack::Response;
use HTTP::Status qw(:constants);
use Locale::TextDomain qw(Lingua-Poly);
use Locale::Messages qw(turn_utf_8_off);
use CGI::Cookie;

# Help cpanm to find dependencies.
use Mojolicious::Plugin::Util::RandomString 0.08;
use Mojolicious::Plugin::RemoteAddr 0.03;

use Lingua::Poly::Util::String qw(empty);
use Lingua::Poly::RestAPI::Logger;
use Lingua::Poly::RestAPI::DB;
use Lingua::Poly::RestAPI::Session;

my $last_cleanup = 0;

sub startup {
	my ($self) = @_;

	$self->moniker('lingua-poly-api');

	$self->plugin('Util::RandomString');
	$self->plugin('RemoteAddr');

	my $config = $self->plugin('YamlConfig');

	if (!$config->{secrets} || !ref $config->{secrets}
	    || 'ARRAY' ne ref $config->{secrets}) {
		my $secret = $self->random_string(entropy => 256);
		$self->log->fatal(<<EOF);
configuration variable "secrets" missing.  Try:

secrets:
- $secret
EOF

		exit 1;
	}

	$config->{database} //= {};
	$config->{database}->{dbname} //= 'linguapoly';
	$config->{database}->{username} //= '';

	$config->{session} //= {};
	$config->{session}->{timeout} ||= 2 * 60 * 60;
	$config->{session}->{cookieName} //= 'id';

	# FIXME! How can we enforce the prefix?
	$config->{path} = '/api/v1';
	$config->{path} = '/';

	$config->{smtp} //= {};
	$config->{smtp}->{host} //= 'localhost';
	$config->{smtp}->{port} //= 1025;

	if (empty $config->{smtp}->{sender}) {
		$self->log->fatal(<<'EOF');
configuration variable "smtp.sender" missing.  Try something like:

smtp:
  sender: Lingua::Poly <do_not_reply@yourdomain.com>

Replace "yourdomain.com" with a suitable domain name.
EOF

		exit 1;
	}

	my $db = Lingua::Poly::RestAPI::DB->new($self->app);
	$self->app->defaults(db => $db);

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

	$self->hook(before_dispatch => sub {
		my ($c) = @_;

		my $now = time;
		if ($now != $last_cleanup) {
			$last_cleanup = $now;
			$db->transaction(
				[ DELETE_USER_STALE => $config->{session}->{timeout} ],
				[ DELETE_SESSION_STALE => $config->{session}->{timeout} ],
				[ DELETE_TOKEN_STALE => $config->{session}->{timeout} ],
			);
		}

		# TODO! Make sure to re-use existing sessions!
		$c->stash->{session} = Lingua::Poly::RestAPI::Session->new($c);
	});
}

1;
