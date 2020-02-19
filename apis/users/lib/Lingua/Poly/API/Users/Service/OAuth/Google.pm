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
	#required => 1,
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

	# Next: Google recommends to use the "sub" claim (concatenate that with
	# "GOOGLE:" in order to satisfy a unique constraint) as the id into the
	# user database because it never changes.  But additionally, we may receive
	# an email address which may or may not exist in our database.  The strategy
	# followed here is:
	#
	# 1. The "sub" claim is enough for us.
	# 2. If the user has a verified email address, it is saved as well.
	# 3. If that email address already exists, the user is updated instead of
	#    being created.
	#
	# The 3rd case is more complicated, when the email address exists but is
	# associated with another user.  The downside of this is that there is
	# one edge case where we find a user both by external id and by their email
	# address, and it refers to different users.  In this case the two accounts
	# are merged, and the information from the social login has precedence.

	my $email = $claims->{email} if $claims->{email_verified};
	$email = $self->emailService->parseAddress($email) if !empty $email;

	my $user = $self->userService->userByExternalId(
		GOOGLE => $claims->{sub}
	);
	my $user_by_email = $self->userService->userByUsernameOrEmail($email)
		if !empty $email;
	my $external_id = "GOOGLE:$claims->{sub}";

	if ($user) {
		if ($user_by_email && $user_by_email->id ne $user->id) {
			# We have to delete the conflicting user in the database and
			# merge the data.
			$user->merge($user_by_email);
			$self->userService->deleteUser($user_by_email);
			$self->userService->updateUser($user);
		}
	} elsif ($user_by_email) {
		# User had logged in before but in another way.
		$user = $user_by_email;
		if (!equals $user->externalId, $user_by_email->externalId) {
			$user->externalId($external_id);
		}
	} else {
		# New user.
		$user = $self->userService->create($email,
			externalId => $external_id,
			confirmed => 1,
		);
	}

	# Not else! Variable $user may have been assiged to!
	if ($user) {
		my $session = $ctx->stash->{session};
		$session->user($user);
		$session->nonce(undef);
		$session->provider('GOOGLE');
		$session->token($payload->{access_token});
		$session->token_expires($now + $payload->{expires_in});
		$self->sessionService->renew($session);
	}

	$self->database->commit;

	return $location;
}

sub revoke {
	my ($self, $token, $token_expires) = @_;

	return $self if $token_expires < time;

	my $discovery = $self->__getDiscoveryConfig
		or die "no discover document\n";

	my $endpoint = $discovery->{revocation_endpoint};
	my $form = {
		token => $token
	};

	$self->debug("revoking token with endpoint '$endpoint'");
	my ($payload, $response) = $self->restService->post($endpoint, $form,
		headers => {
			content_type => 'application/x-www-form-urlencoded'
		}
	);
	if (!$response->status_line) {
		my $msg = $response->status_line;
		$self->warning("token could not be revoked: $msg");
	}

	return $self;
}

__PACKAGE__->meta->make_immutable;

1;
