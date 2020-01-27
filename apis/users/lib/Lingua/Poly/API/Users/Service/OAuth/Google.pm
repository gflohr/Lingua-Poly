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

package Lingua::Poly::API::Users::Service::OAuth::Google;

use strict;

use Moose;
use namespace::autoclean;
use LWP::UserAgent;
use HTTP::Request;
use JSON;
use Mojo::URL;

use Lingua::Poly::API::Users::Util qw(empty equals decode_jwt);
use Lingua::Poly::API::Users::Service::OAuth::Google::Discovery;

use base qw(Lingua::Poly::API::Users::Logging);

use constant DISCOVERY_DOCUMENT
	=> 'https://accounts.google.com/.well-known/openid-configuration';

has logger => (is => 'ro', required => 1);
has configuration => (is => 'ro', required  => 1);
has database  => (
	is => 'ro',
	required => 1,
	isa => 'Lingua::Poly::API::Users::Service::Database',
);
has discovery  => (
	is => 'rw',
	required => 0,
	isa => 'Lingua::Poly::API::Users::Service::OAuth::Google::Discovery',
);
has requestContextService => (
	is => 'ro',
	required => 1,
	isa => 'Lingua::Poly::API::Users::Service::RequestContext',
);
has sessionService => (
	is => 'ro',
	required => 1,
	isa => 'Lingua::Poly::API::Users::Service::Session',
);
has restService => (
	isa => 'Lingua::Poly::API::Users::Service::RESTClient',
	is => 'ro',
	required => 1,
);
has userService => (
	isa => 'Lingua::Poly::API::Users::Service::User',
	is => 'ro',
	required => 1,
);
has emailService => (
	isa => 'Lingua::Poly::API::Users::Service::Email',
	is => 'ro',
	required => 1,
);

sub __getDiscoveryConfig {
	my ($self) = @_;

	my $discovery = $self->discovery;
	return $discovery->config if $discovery && time < $discovery->expires;

	my $ua = LWP::UserAgent->new(timeout => 2);

	$self->info("retrieving Google OpenID Connect discovery document from '"
		. DISCOVERY_DOCUMENT . "'");
	my $request = HTTP::Request->new(GET => DISCOVERY_DOCUMENT);
	my $response = $ua->request($request);
	if (!$response->is_success) {
		if ($discovery) {
			$self->error($response->status_line);
		} else {
			$self->error($response->status_line);
			die "cannot proceed";
		}
	}

	my $d = Lingua::Poly::API::Users::Service::OAuth::Google::Discovery->new(
		expires => $response->freshness_lifetime + time,
		config => JSON->new->decode($response->decoded_content),
	);
	$self->discovery($d);

	return $d->config;
}

sub redirectUri {
	my ($self, $ctx) = @_;

	my $redirect_url = $self->requestContextService->origin($ctx)->clone;

	my $config = $self->configuration;

	$redirect_url->path("$config->{prefix}/oauth/google");

	return $redirect_url;
}

sub authorizationUrl {
	my ($self, $ctx) = @_;

	my $config = $self->configuration;
	my $client_id = $config->{oauth}->{google}->{client_id};
	return if empty $client_id;

	my $client_secret = $config->{oauth}->{google}->{client_secret};
	return if empty $client_secret;

	my $redirect_uri = $self->redirectUri($ctx);

	my $session = $ctx->stash->{session};

	my $discovery = $self->__getDiscoveryConfig or return;

	my $authorization_url = $discovery->{authorization_endpoint};
	$authorization_url = URI->new($authorization_url);
	$authorization_url->query_form(
		client_id => $client_id,
		response_type => 'code',
		scope => 'openid email',
		redirect_uri => $redirect_uri,
		state => $self->sessionService->getState($session),
		nonce => $session->nonce,
	);

	return $authorization_url;
}

sub authenticate {
	my ($self, $ctx, %params) = @_;

	my $discovery = $self->__getDiscoveryConfig
		or die "no discover document\n";

	my $config = $self->configuration;

	my $client_id = $config->{oauth}->{google}->{client_id}
		or die "no google client id\n";
	my $client_secret = $config->{oauth}->{google}->{client_secret}
		or die "no google client secret\n";

	my $session = $ctx->stash->{session};
	my $state = $self->sessionService->getState($session);
	die "state mismatch\n" if $params{state} ne $state;

	my $redirect_uri = $self->redirectUri($ctx);

	my $form = {
		code => $params{code},
		client_id => $client_id,
		client_secret => $client_secret,
		redirect_uri => $redirect_uri->to_string,
		grant_type => 'authorization_code',
	};

	my $token_endpoint = $discovery->{token_endpoint};

	my ($payload, $response) = $self->restService->post($token_endpoint, $form,
		headers => {
			content_type => 'application/x-www-form-urlencoded'
		}
	);
	die $response->status_line if !$response->is_success;

	my $now = time;

	my $claims = decode_jwt $payload->{id_token};
	die "client_id mismatch\n" if $claims->{aud} ne $client_id;
	die "issuer mismatch\n" if $claims->{iss} ne $discovery->{issuer};
	die "missing exp claim\n" if !exists $claims->{exp};
	die "missing iat claim\n" if !exists $claims->{iat};
	$self->warn('clock skew detected (Google)') if $now < $claims->{iat};
	$self->warn('clock lag detected (Google)') if ($now - 60) > $claims->{iat};

	# The rest of this method should probably go into a dedicated method
	# of the user service because Facebook login will probably require the
	# same logic.  It is also easier to test..
	my $location = Mojo::URL->new($self->configuration->{origin});

	# Next: Google recommends to use the 'sub' claim (concatenate that with
	# "GOOGLE:" in order to satisfy a unique constraint) as the id into the
	# user database because it never changes.  This does not satisfy our
	# requirements.  The purpose of the OAuth flow for us is to have a
	# reliable email address.  We use the 'sub' claim only as a fallback to
	# find an old email of that user.
	#
	# One particularly nasty case can occur if we have two users that match,
	# one by email, one by the external id. In this case, we delete the user
	# with the conflicting external id.

	my $email = $claims->{email} if $claims->{email_verified};
	my $email_verified = $claims->{email_verified};
	$email = $self->emailService->parseAddress($email) if $email;

	my $user_by_external_id = $self->userService->userByExternalId(
		GOOGLE => $claims->{sub}
	);
	my $user = $self->userService->userByUsernameOrEmail($email) if $email;
	my $external_id = "GOOGLE:$claims->{sub}";

	if ($user) {
		if ($user_by_external_id) {
			if ($user->id ne $user_by_external_id->id) {
				# Delete the conflicting user.  FIXME! Inform about that?
				$self->userService->deleteUser($user_by_external_id);
			} elsif (!equals $external_id, $user->externalId) {
				# Update the user.
				$user->externalId($external_id);
				$self->userService->update($user);
			}
		} else {
			# There is no user with that external id.  That means we have to
			# update the user that we have found by email.
			$self->userService->update($user);
		}
	} elsif ($user_by_external_id) {
		# The users email must have changed.  FIXME! Inform about that?
		$user = $user_by_external_id;
		$self->userService->update($user);
	}

	# Not else! Variable $user may have been assiged to!
	if (!$user) {
		if (!$email) {
			$location->query(error => 'ERROR_NO_EMAIL_PROVIDED');
		} elsif (!$email_verified) {
			$location->query(error => 'ERROR_GOOGLE_EMAIL_NOT_VERIFIED');
		} else {
			$user = $self->userService->create($email,
				externalId => $external_id,
				confirmed => 1,
			);
		}
	}

	# Not else! Variable $user may have been assiged to!
	if ($user) {
		my $session = $ctx->stash->{session};
		$session->user($user);
		$session->nonce(undef);
		$session->provider('GOOGLE');
		$self->sessionService->renew($session);
		$self->database->commit;
	}

	return $location;
}

__PACKAGE__->meta->make_immutable;

1;
