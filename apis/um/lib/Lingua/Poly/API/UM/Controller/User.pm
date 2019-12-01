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

	my $session = $self->stash->{session};
	$self->app->sessionService->renew($session);
	$self->app->database->commit;

	my %user = (
		sessionTTL => $self->config->{session}->{timeout},
	);
	$user{email} = $user->email if defined $user->email;
	$user{username} = $user->username if defined $user->username;
	$self->app->requestContextService->sessionCookie($self, $session);

	$self->render(openapi => \%user, status => HTTP_OK);
}

sub profile {
	my $self = shift->openapi->valid_input or return;

	my %user = (
		email => 'karl.dapp@der.abwaschba.re',
		username => 'Karl Dapp',
		sessionTTL => $self->config->{session}->{timeout},
	);

	return $self->render(openapi => \%user, status => HTTP_OK);

	return $self->errorResponse(HTTP_UNAUTHORIZED, {
		message => 'You are not logged in.'
	});
}

1;
