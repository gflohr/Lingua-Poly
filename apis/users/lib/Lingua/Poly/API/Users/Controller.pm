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

package Lingua::Poly::API::Users::Controller;

use strict;

use HTTP::Status qw(:constants);
use Mojo::URL;

use Mojo::Base ('Mojolicious::Controller', 'Lingua::Poly::API::Users::Logging');

sub errorResponse {
	my ($self, $code, $errors, %options) = @_;

	$code ||= HTTP_BAD_REQUEST;

	$self->res->headers->content_type('application/problem+json; charset=utf-8');

	my $data = { errors => $errors, %options };

	return $self->render(openapi => $data, status => $code);
}

# FIXME! Inline where needed!
sub realm {
	my $realm = __PACKAGE__;
	$realm =~ s/::([^:]+::Controller::.*)/$1/;
}

sub logger {
	my ($self) = @_;

	return $self->{_logger} if exists $self->{_logger};
	my $app = $self->app;

	my $context = ref $self;
	$context =~ s/.*::Controller::/Controller::/;

	# FIXME! Can we use the SmartLogger constructor here?
	return $self->{_logger} = $app->log->context("[$context]");
}

sub fingerprint {
	my ($self) = @_;

}

sub siteURL {
	my ($self) = @_;

	my $req_url = $self->req->url->to_abs;
	my $url = Mojo::URL->new;
	$url->scheme($req_url->scheme);
	$url->host($req_url->host);
	$url->port($req_url->port);

	return $url;
}

1;
