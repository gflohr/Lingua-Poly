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

__PACKAGE__->meta->make_immutable;

1;
