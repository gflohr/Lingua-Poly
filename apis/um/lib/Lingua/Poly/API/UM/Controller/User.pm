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

package Lingua::Poly::API::UM::Controller::User;

use strict;

use HTTP::Status qw(:constants);

use Lingua::Poly::API::UM::Util qw(empty crypt_password check_password);

use Mojo::Base qw(Lingua::Poly::API::UM::Controller);

sub login {
	my $self = shift->openapi->valid_input or return;

	my $login_data = $self->req->json;
	my $db = $self->app->database;

	my $user = $self->app->userService->userByUsernameOrEmail($login_data->{id});
	return $self->errorResponse(HTTP_UNAUTHORIZED, {
		message => 'invalid username or password'
	}) if !$user || !$user->confirmed;
	return $self->errorResponse(HTTP_UNAUTHORIZED, {
		message => 'invalid username or password'
	}) if !check_password $login_data->{password}, $user->password;

	# Upgrade the session with a valid user.
	my $session = $self->stash->{session};
	$session->user($user);
	$self->app->sessionService->renew($session);
	$self->app->database->commit;

	my %user;
	$self->res->headers('X-Session-TTL', $self->config->{session}->{timeout});
	$user{email} = $user->email if defined $user->email;
	$user{username} = $user->username if defined $user->username;

	$self->render(openapi => \%user, status => HTTP_OK);
}

sub logout {
	my $self = shift->openapi->valid_input or return;

	my $app = $self->app;

	# Downgrade the session.  This is an authenticated request.  So we don't
	# get here if the user does not have a valid session.
	$app->sessionService->delete($self->stash->{session});
	my $fingerprint = $app->requestContextService->fingerprint($self);
	my $session_id = $app->requestContextService->sessionID($self);
	$self->stash->{session}
		= $app->sessionService->refreshOrCreate($session_id, $fingerprint);
	$app->database->commit;

	$self->render(json => '', status => HTTP_NO_CONTENT);
}

sub profile {
	my $self = shift->openapi->valid_input or return;

	my $user = $self->stash->{session}->user;

	my %user = $user->toResponse('self');

	$self->res->headers('X-Session-TTL', $self->config->{session}->{timeout});

	# FIXME! The validation fails here because the OpenAPI plug-in seems to not
	# support allOf.
	#return $self->render(openapi => \%user, status => HTTP_OK);
	return $self->render(json => \%user, status => HTTP_OK);
}

sub get {
	my $self = shift->openapi->valid_input or return;

	my $name = $self->param('name');

	my $user = $self->app->userService->userByUsernameOrEmail($name);
	if (!$user) {
		return $self->errorResponse(
			HTTP_NOT_FOUND, {
		    message => 'invalid username or password'
		});
	}

	my %user = $user->toResponse;

	return $self->render(openapi => \%user, status => HTTP_OK);
}

1;
