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

package Lingua::Poly::API::Users::Controller::User;

use strict;

use HTTP::Status qw(:constants);
use URI;
use Data::Password::zxcvbn 1.0.4 qw(password_strength);
use Lingua::Poly::API::Users::Util qw(check_password);

use Mojo::Base qw(Lingua::Poly::API::Users::Controller);

sub login {
	my $self = shift->openapi->valid_input or return;

	my $identity_provider = $self->app->sessionService->identityProvider(
		local => $self
	);

	my $credentials = $self->req->json;

	my $user = $identity_provider->authenticate($credentials);
	if (!$user) {
		return $self->errorResponse(HTTP_UNAUTHORIZED, {
			message => 'invalid username or password'
		});
	}

	# Upgrade the session with a valid user.
	my $session = $self->stash->{session};
	$session->user($user);
	$session->nonce(undef);
	$self->app->sessionService->renew($session);
	$self->app->database->commit;

	$self->res->headers('X-Session-TTL', $self->config->{session}->{timeout});
	my %user = $user->toResponse('private');

	# FIXME! The validation fails here because the OpenAPI plug-in seems to not
	# support allOf.
	#return $self->render(openapi => \%user, status => HTTP_OK);
	return $self->render(json => \%user, status => HTTP_OK);
}

sub logout {
	my $self = shift->openapi->valid_input or return;

	my $app = $self->app;

	my $provider = $self->stash->{session}->provider;
	my $identity_provider = $self->app->sessionService->identityProvider(
		$provider => $self
	);

	$identity_provider->signOut;
	$self->app->database->commit;

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

sub updateProfile {
	my $self = shift->openapi->valid_input or return;

	my $user = $self->stash->{session}->user;
	my $json = $self->req->json;

	$user->username($json->{username});
	$user->homepage($json->{homepage});
	$user->description($json->{description});

	eval {
		$self->app->userService->updateUser($user);
	};
	if ($@) {
		$self->error($@);
		return $self->errorResponse(HTTP_BAD_REQUEST, {
			message => 'invalid user properties'
		});
	}

	return $self->render(json => '', status => HTTP_NO_CONTENT);
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

sub changePassword {
	my $self = shift->openapi->valid_input or return;

	my $changeSet = $self->req->json;

	my $user = $self->stash->{session}->user;

	if (!$user->password) {
		return $self->errorResponse(
			HTTP_FORBIDDEN, {
				message => 'user does not have a password'
			}
		);
	}

	if (!check_password $changeSet->{oldPassword}, $user->password) {
		return $self->errorResponse(
			HTTP_FORBIDDEN, {
				message => 'invalid password'
			}
		);
	}

	my $analysis = password_strength $changeSet->{password};
	my $score = $analysis->{score};
	if ($score < 3) {
		return $self->errorResponse(
			HTTP_BAD_REQUEST, {
				message => "Password too weak (score: $score/3).",
			}
		);
	}

	$self->app->userService->changePassword($user, $changeSet->{password});
	$self->app->sessionService->privilegeLevelChange($self);

	return $self->render(json => '', status => HTTP_NO_CONTENT);
}

sub resetPassword {
	my $self = shift->openapi->valid_input or return;

	my $json = $self->req->json;

	$self->app->userService->resetPassword($json->{id});

	return $self->render(json => '', status => HTTP_NO_CONTENT);
}

1;
