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

package Lingua::Poly::API::Users::Service::Session;

use strict;

use Moose;
use namespace::autoclean;

use Session::Token;
use Digest::SHA qw(sha256_base64 hmac_sha256);
use MIME::Base64 qw(encode_base64url);
use String::Compare::ConstantTime 0.321;

use Lingua::Poly::API::Users::Model::User;
use Lingua::Poly::API::Users::Model::Session;
use Lingua::Poly::API::Users::SmartLogger;
use Lingua::Poly::API::Users::Util qw(empty);

use base qw(Lingua::Poly::API::Users::Logging);

has logger => (
	is => 'ro',
	isa => 'Lingua::Poly::API::Users::SmartLogger',
	required => 1
);
has database => (
	is => 'ro',
	isa => 'Lingua::Poly::API::Users::Service::Database',
	required => 1
);
has configuration => (
	is => 'ro',
	required => 1
);
has userService => (
	is => 'ro',
	isa => 'Lingua::Poly::API::Users::Service::User',
	required => 1
);
has requestContextService => (
	is => 'ro',
	isa => 'Lingua::Poly::API::Users::Service::RequestContext',
	required => 1
);

my $last_cleanup = 0;

sub realm { 'session' }

sub maintain {
	my ($self) = @_;

	# Clean-up at most once per second.
	my $now = time;
	return $self if $now <= $last_cleanup;

	$self->info('doing maintainance');

	my $config = $self->configuration;

	$last_cleanup = $now;
	$self->database->transaction(
		[ DELETE_USER_STALE => $config->{session}->{timeout} ],
		[ DELETE_SESSION_STALE => $config->{session}->{timeout} ],
		[ DELETE_TOKEN_STALE => $config->{session}->{timeout} ],
		[ DELETE_AUTH_TOKEN_STALE => $config->{session}->{remember} ],
	);

	return $self;
}

sub identityProvider {
	my ($self, $provider, $ctx) = @_;

	$provider = ucfirst lc $provider;
	my $class = "Lingua::Poly::API::Users::IdentityProvider::$provider";
	my $module = $class;
	$module =~ s{::}{/}g;
	$module .= '.pm';

	require $module;

	my $logger = Lingua::Poly::API::Users::SmartLogger->new(
		realm => $class->realm
	);

	return $class->new(context => $ctx, logger => $logger);
}

sub digest {
	my ($self, $sid) = @_;

	return if empty $sid;

	return sha256_base64 $sid;
}

sub refreshOrCreate {
	my ($self, $ctx, $sid, $fingerprint) = @_;

	my $database = $self->database;

	my $sid_digest = $self->digest($sid);

	my $raw_session;
	if (defined $sid_digest) {
		$self->debug(<<EOF);
Read from cookie:
	SID: $sid
	Digest: $sid_digest
EOF
		my @row = $database->getRow(SELECT_SESSION => $sid_digest, $fingerprint);
		if (@row) {
			my ($user_id, $provider, $token, $token_expires, $nonce) = @row;
			$raw_session = {
				sid => $sid,
				user_id => $user_id,
				provider => $provider,
				token => $token,
				token_expires => $token_expires,
				nonce => $nonce,
			};
		}
	} else {
		$self->debug('no session cookie');
	}

	if ($raw_session) {
		$self->debug(<<EOF);
Refresh existing session:
	SID: $sid
	Digest: $sid_digest
EOF
		$database->execute(UPDATE_SESSION => $sid_digest);
	} else {
		$raw_session = {
			provider => 'local',
		};
		$sid = $raw_session->{sid} = Session::Token->new(entropy => 256)->get;
		$sid_digest = $self->digest($sid);
		$self->debug(<<EOF);
Create new session:
	SID: $sid
	Digest: $sid_digest
EOF

		my $nonce = $raw_session->{nonce} = Session::Token->new(entropy => 128)->get;
		$database->execute(INSERT_SESSION => $sid_digest,
			$fingerprint, 'local', $nonce);
	}

	my $user_id = delete $raw_session->{user_id};
	my ($auth_selector, $auth_token);
	my $auth_token_value = $self->requestContextService->authToken($ctx);
	if (!empty $auth_token_value) {
		($auth_selector, $auth_token) = $self->__splitAuthCookie($auth_token_value);
		$database->execute(UPDATE_AUTH_TOKEN => $auth_selector);
	}

	# Try the long-term cookie.
	if (!defined $user_id) {
		if (!empty $auth_token_value) {
			my $auth_token_digest;
			($user_id, $auth_token_digest) = $database->getRow(
				SELECT_AUTH_TOKEN => $auth_selector
			);

			if (!empty $auth_token_digest && !empty $user_id) {
				if (!String::Compare::ConstantTime::equals(
					$auth_token_digest, $self->digest($auth_token))) {
					$self->deleteAuthCookie($ctx, $auth_token_value);
					undef $user_id;
				}
			}
		}
	}

	if (defined $user_id) {
		my $user = $self->userService->userById($user_id);
		if ($user && $user->confirmed) {
			$raw_session->{user} = $user;
		}
	}

	$database->commit;

	return Lingua::Poly::API::Users::Model::Session->new(%$raw_session);
}

sub __splitAuthCookie {
	my ($self, $value) = @_;

	my $l = length $value;
	$l >>= 1;

	my $selector = substr $value, 0, $l;
	my $token = substr $value, $l;

	return $selector, $token;
}

sub create {
	my ($self, $sid) = @_;

	return Lingua::Poly::API::Users::Model::Session->new(sid => $sid);
}

sub renew {
	my ($self, $session) = @_;

	my $sid = Session::Token->new(entropy => 256)->get;
	my $sid_digest = $self->digest($sid);

	my $user = $session->user;
	my $user_id = $user ? $user-> id : undef;

	$self->database->execute(
		UPDATE_SESSION_SID =>
			$sid_digest,
			$user_id,
			$session->provider,
			$session->token,
			$session->token_expires,
			$session->nonce,
			$self->digest($session->sid)
	);
	$session->sid($sid);

	return $self;
}

sub delete {
	my ($self, $session) = @_;

	$self->database->execute(DELETE_SESSION => $self->digest($session->sid));

	return $self;
}

sub updateNonce {
	my ($self, $session) = @_;

	$self->database->execute(
		UPDATE_SESSION_NONCE => $session->nonce, $self->digest($session->sid));

	return $self;
}

sub getNonce {
	my ($self, $session) = @_;

	my ($nonce) = $self->database->getRow(
		SELECT_SESSION_NONCE => $self->digest($session->sid));

	return $nonce;
}

sub getState {
	my ($self, $session) = @_;

	my $secret = $self->configuration->secret;

	return encode_base64url hmac_sha256 $session->sid, $secret;
}

sub privilegeLevelChange {
	my ($self, $ctx) = @_;

	my $session = $ctx->stash->{session};
	$session->nonce(Session::Token->new(entropy => 128)->get);
	$self->renew($session);

	return $self;
}

sub remember {
	my ($self, $ctx, $user) = @_;

	my $config = $self->configuration;

	my $entropy = $config->{session}->{entropy}->{remember};
	my $token = Session::Token->new(entropy => $entropy)->get;
	my $selector = Session::Token->new(entropy => $entropy)->get;
	my $token_digest = $self->digest($token);

	my $db = $self->database;
	$db->execute(INSERT_AUTH_TOKEN => $user->id, $token_digest, $selector);

	my $cookie_name = $config->{session}->{rememberCookie};
	my $cookie_value = $selector . $token;

	$ctx->cookie($cookie_name => $cookie_value, {
		path => $config->{prefix},
		httponly => 1,
		secure => $ctx->req->is_secure,
		expires => time + $config->{session}->{remember},
	});

	return $self;
}

sub deleteAuthCookie {
	my ($self, $ctx, $cookie) = @_;

	my ($selector, undef) = $self->__splitAuthCookie($cookie);
	$self->database->execute(DELETE_AUTH_TOKEN => $selector);
	my $cookie_name = $self->configuration->{session}->{rememberCookie};

	$ctx->cookie($cookie_name => '', { expires => 0 });

	return $self;
}

__PACKAGE__->meta->make_immutable;

1;
