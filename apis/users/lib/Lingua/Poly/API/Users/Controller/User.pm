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

use Lingua::Poly::API::Users::Util qw(empty crypt_password check_password);

use Mojo::Base qw(Lingua::Poly::API::Users::Controller);

my $google_oid_configuration;

use constant GOOGLE_OID_CONFIGURATION_URL =>
	'https://accounts.google.com/.well-known/openid-configuration';

sub login {
	my $self = shift->openapi->valid_input or return;

	my $login_data = $self->req->json;
	my $db = $self->app->database;

	$self->info("user '$login_data->{id}' trying to log in");

	my $user = $self->app->userService->userByUsernameOrEmail($login_data->{id});
	if (!$user || !$user->confirmed) {
		if (!$user) {
			$self->debug("user '$login_data->{id}' is unknown");
		} elsif (!$user->confirmed) {
			$self->debug("user '$login_data->{id}' is unconfirmed");
		}
		return $self->errorResponse(HTTP_UNAUTHORIZED, {
			message => 'invalid username or password'
		});
	}
	if (!check_password $login_data->{password}, $user->password) {
		$self->debug("user '$login_data->{id}': invalid credentials");
		return $self->errorResponse(HTTP_UNAUTHORIZED, {
			message => 'invalid username or password'
		})
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

sub oauth2Login {
	my $self = shift->openapi->valid_input or return;

	my $payload = $self->req->json;
	my $db = $self->app->database;

	# FIXME! This must go into a separate OAuth2Service!
	my ($social_user, $response);
	if ('FACEBOOK' eq $payload->{provider}) {
		my $auth_url = URI->new('https://graph.facebook.com/v5.0/me/');
		$auth_url->query_form(
			access_token => $payload->{token},
			fields => 'email,name',
			method => 'get',
		);
		($social_user, $response) = $self->app->restService->get($auth_url);
		return $self->errorResponse(HTTP_UNAUTHORIZED, {
			message => $social_user->{error}->{message}
		}) if $social_user->{error};
		return $self->errorResponse(HTTP_UNAUTHORIZED, {
			message => "lingua-poly-error:no-email"
		}) if !$social_user->{email};
	} elsif ('GOOGLE' eq $payload->{provider}) {
		if (!$google_oid_configuration) {
			($google_oid_configuration) =
				$self->app->restService->get(GOOGLE_OID_CONFIGURATION_URL, '');
		}
		die "cannot get Google openid configuration\n"
			if !$google_oid_configuration;
		my $url = URI->new($google_oid_configuration->{userinfo_endpoint});
		($social_user, $response) = $self->app->restService->get($url, '',
			headers => {
				authorization => "Bearer $payload->{token}",
			}
		);
		return $self->errorResponse(HTTP_UNAUTHORIZED, {
			message => $social_user->{error_description}
		}) if $social_user->{error};
		return $self->errorResponse(HTTP_UNAUTHORIZED, {
			message => "lingua-poly-error:no-email"
		}) if !$social_user->{email};
		return $self->errorResponse(HTTP_UNAUTHORIZED, {
			message => "lingua-poly-error:email-not-verified"
		}) if !$social_user->{email_verified};
	} else {
		die "Identity provider '$payload->{provider}' is not supported.\n";
	}

	my $user = $self->app->userService->userByUsernameOrEmail($social_user->{email});
	if (!$user) {
		# Create a new user that is immediately confirmed.
		my $user_id = $self->app->userService->create($social_user->{email});
		$user = Lingua::Poly::API::Users::Model::User->new(
			id => $user_id,
			email => $social_user->{email},
		);
		$self->app->userService->activate($user);
	}

	my $session = $self->stash->{session};
	$session->user($user);
	$session->nonce(undef);
	$session->provider($payload->{provider});
	$session->token($payload->{token});
	$self->app->sessionService->renew($session);
	$self->app->database->commit;

	my %user = $user->toResponse('private');
	return $self->render(json => \%user, status => HTTP_OK);
}

sub logout {
	my $self = shift->openapi->valid_input or return;

	my $app = $self->app;

	my $session = $self->stash->{session};

	# Make a copy of the provider and the access token so that we can revoke
	# permissions.
	my $provider = $session->provider;
	my $token = $session->token;

	# Downgrade the session.  This is an authenticated request.  So we don't
	# get here if the user does not have a valid session.
	$app->sessionService->delete($session);

	my $fingerprint = $app->requestContextService->fingerprint($self);
	my $session_id = $app->requestContextService->sessionID($self);
	$self->stash->{session}
		= $app->sessionService->refreshOrCreate($session_id, $fingerprint);
	$app->database->commit;

	# FIXME! Move that into an oauth2 service.
	if ('FACEBOOK' eq $provider) {
		my $url = URI->new('https://graph.facebook.com/');
		$url->path('/me/permissions');
		my ($data, $response) = $self->app->restService->delete(
			$url,
			'',
			headers => {
				Authorize => "Bearer $token"
			}
		);
		if (!$response->is_success) {
			$self->warn("cannot revoke access token, code: " . $response->code);
		} elsif (!$data->{success}) {
			$self->warn("cannot revoke access token: " . $data->{error}->{message});
		}
	}

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

1;
