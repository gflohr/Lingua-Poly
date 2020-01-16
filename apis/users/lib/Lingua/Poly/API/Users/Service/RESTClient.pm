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

package Lingua::Poly::API::Users::Service::RESTClient;

use strict;

use Moose;
use namespace::autoclean;

use LWP::UserAgent;
use HTTP::Request;
use JSON;

use base qw(Lingua::Poly::API::Users::Logging);

has logger => (is => 'ro');
has ua => (
	isa => 'LWP::UserAgent',
	is => 'ro',
	builder => '__build_ua',
);

sub __build_ua {
	return LWP::UserAgent->new;
}

sub get {
	my ($self, $uri, $content, %options) = @_;

	return $self->request(GET => $uri, $content, %options);
}

sub delete {
	my ($self, $uri, $content, %options) = @_;

	return $self->request(DELETE => $uri, $content, %options);
}

sub request {
	my ($self, $method, $uri, $content, %options) = @_;

	$content = '{}' if !defined $content;

	my @headers = (
		accept => 'application/json',
		content_type => 'application/json; charset=UTF-8'
	);

	foreach my $key (keys %{$options{headers} || {}}) {
		push @headers, $key, $options{headers}->{$key};
	}

	#$self->info("sending request with method '$method' to '$uri'");
	my $request = HTTP::Request->new($method, $uri, \@headers, $content);
	my $ua = $self->ua;
	my $response = $self->ua->request($request);

	my $ct = $response->content_type;
	my $response_content = $response->content;
	return $response_content, $response if $ct !~ m{^application/json};

	my $payload = JSON->new->decode($response_content);

	return $payload, $response;
}

__PACKAGE__->meta->make_immutable;

1;
