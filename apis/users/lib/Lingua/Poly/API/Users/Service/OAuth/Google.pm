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

use Lingua::Poly::API::Users::Util qw(empty);
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

sub authorizationUrl {
	my ($self, $ctx) = @_;

	my $config = $self->configuration;
	my $client_id = $config->{oauth}->{google}->{client_id};
	return if empty $client_id;

	my $client_secret = $config->{oauth}->{google}->{client_secret};
	return if empty $client_secret;

	my $redirect_url = $self->requestContextService->origin($ctx)->clone;
	$redirect_url->path('/oauth/google');

	my $session = $ctx->stash->{session};

	my $discovery = $self->__getDiscoveryConfig or return;

	my $authorization_url = $discovery->{authorization_endpoint};
	$authorization_url = URI->new($authorization_url);
	$authorization_url->query_form(
		client_id => $client_id,
		response_type => 'code',
		scope => 'openid email',
		redirect_uri => $redirect_url,
		state => $self->sessionService->getState($session),
		nonce => $session->nonce,
	);

	return $authorization_url;
}

__PACKAGE__->meta->make_immutable;

1;
