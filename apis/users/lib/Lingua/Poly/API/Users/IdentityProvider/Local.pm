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

package Lingua::Poly::API::Users::IdentityProvider::Local;

use strict;

use Moose;
use namespace::autoclean;

use Lingua::Poly::API::Users::Util qw(check_password);

use base qw(Lingua::Poly::API::Users::Logging);

has context => (
	is => 'ro',
	required => 1,
	isa => 'Mojolicious::Controller',
);
has logger => (
	is => 'ro',
	required => 1,
	isa => 'Mojo::Log',
);

sub realm { 'authentication' }

sub authenticate {
	my ($self, $credentials) = @_;

	my $app = $self->context->app;

	my $db = $app->database;

	$self->info("user '$credentials->{id}' trying to log in");

	my $user = $app->userService->userByUsernameOrEmail($credentials->{id});
	if (!$user || !$user->confirmed) {
		if (!$user) {
			$self->debug("user '$credentials->{id}' is unknown");
		} elsif (!$user->confirmed) {
			$self->debug("user '$credentials->{id}' is unconfirmed");
		}
		return;
	}

	if (!check_password $credentials->{password}, $user->password) {
		$self->debug("user '$credentials->{id}': invalid credentials");
		return;
	}

	return $user;
}

sub signOut {
	my ($self) = @_;

	my $context = $self->context;
	my $app = $context->app;
	my $session = $context->stash->{session};

	# Downgrade the session.  This is an authenticated request.  So we don't
	# get here if the user does not have a valid session.
	$app->sessionService->delete($session);

	my $fingerprint = $app->requestContextService->fingerprint($context);
	my $session_id = $app->requestContextService->sessionID($context);
	my $auth_token = $app->requestContextService->authToken($context);
	if ($auth_token) {
		$app->sessionService->deleteAuthCookie($context, $auth_token);
	}
	$session = $app->sessionService->create($session->sid);
	$app->sessionService->renew($session);
	$context->stash->{session} = $session;

	return $self;
}

__PACKAGE__->meta->make_immutable;

1;

