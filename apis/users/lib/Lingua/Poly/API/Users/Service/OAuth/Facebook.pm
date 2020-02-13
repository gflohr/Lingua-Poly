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

package Lingua::Poly::API::Users::Service::OAuth::Facebook;

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

has logger => (is => 'ro', required => 1);
has configuration => (is => 'ro', required  => 1);
has database  => (
	is => 'ro',
	required => 1,
);
has requestContextService => (
	is => 'ro',
	required => 1,
	#isa => 'Lingua::Poly::API::Users::Service::RequestContext',
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

# FIXME! Factor that out into a base class method.
sub redirectUri {
	my ($self, $ctx) = @_;

	my $redirect_url = $self->requestContextService->origin($ctx)->clone;

	my $config = $self->configuration;

	$redirect_url->path("$config->{prefix}/oauth/facebook");

	return $redirect_url;
}

sub authorizationUrl {
	my ($self, $ctx) = @_;

	my $config = $self->configuration;
	my $client_id = $config->{oauth}->{facebook}->{client_id};
	return if empty $client_id;

	my $client_secret = $config->{oauth}->{facebook}->{client_secret};
	return if empty $client_secret;

	my $redirect_uri = $self->redirectUri($ctx);

	my $session = $ctx->stash->{session};

	my $authorization_url = URI->new('https://www.facebook.com/v6.0/dialog/oauth');
	$authorization_url->query_form(
		client_id => $client_id,
		redirect_uri => $redirect_uri,
		state => $self->sessionService->getState($session),
		response_type => 'code',
		scope => 'email',
	);

	return $authorization_url;
}

sub authenticate {
	my ($self, $ctx, %params) = @_;

	my $config = $self->configuration;

	my $client_id = $config->{oauth}->{facebook}->{client_id}
		or die "no facebook client id\n";
	my $client_secret = $config->{oauth}->{facebook}->{client_secret}
		or die "no facebook client secret\n";

	my $session = $ctx->stash->{session};
	my $state = $self->sessionService->getState($session);
	die "state mismatch\n" if $params{state} ne $state;

	my $redirect_uri = $self->redirectUri($ctx);

	my $form = {
		code => $params{code},
		client_id => $client_id,
		client_secret => $client_secret,
		redirect_uri => $redirect_uri->to_string,
	};

	my $token_endpoint = URI->new(
		'https://graph.facebook.com/v6.0/oauth/access_token'
	);
	$token_endpoint->query_form($form);

	my ($payload, $response) = $self->restService->get($token_endpoint);
	my $now = time;
	die $response->status_line if !$response->is_success;

	die "facebook did not send an access token"
		if empty $payload->{access_token};
	my $access_token = $payload->{access_token};
	my $expires_in = $payload->{expires_in};
	# Verify the access token.
	my $debug_endpoint = URI->new('https://graph.facebook.com/debug_token');
	$debug_endpoint->query_form(
		input_token => $access_token,
		access_token => $client_id,
	);

	($payload, $response) = $self->restService->get($debug_endpoint);
	die $response->status_line if !$response->is_success;

	use Data::Dumper;
	die Dumper $payload;

	my $location = Mojo::URL->new($self->configuration->{origin});

my $claims = {};
	my $email = $claims->{email} if $claims->{email_verified};
	$email = $self->emailService->parseAddress($email) if !empty $email;

	my $user = $self->userService->userByExternalId(
		FACEBOOK => $claims->{sub}
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

	die;
}

__PACKAGE__->meta->make_immutable;

1;
