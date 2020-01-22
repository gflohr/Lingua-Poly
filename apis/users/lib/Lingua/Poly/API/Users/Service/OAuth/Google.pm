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

use Lingua::Poly::API::Users::Util qw(empty decode_jwt);
use Lingua::Poly::API::Users::Service::OAuth::Google::Discovery;

use base qw(Lingua::Poly::API::Users::Logging);

use constant DISCOVERY_DOCUMENT
	=> 'https://accounts.google.com/.well-known/openid-configuration';

has logger => (is => 'ro', required => 1);
has configuration => (is => 'ro', required  => 1);
has database => (
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

	my $claims = decode_jwt $payload->{id_token};
	die "issuer mismatch\n" if $claims->{iss} ne $discovery->{issuer};

	use Data::Dumper;
	warn Dumper $claims;

	return $self;
}

__PACKAGE__->meta->make_immutable;

1;
