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

# ABSTRACT: User management API for Lingua-Poly.

package Lingua::Poly::API::Users;

use strict;

use Mojo::Base ('Mojolicious', 'Lingua::Poly::API::Users::Logging');

use Time::HiRes qw(gettimeofday);
use YAML;
use HTTP::Status qw(:constants);
use CGI::Cookie;

# FIXME! RandomString no longer needed?
use Mojolicious::Plugin::Util::RandomString 0.08;
use Mojolicious::Plugin::RemoteAddr 0.03;

use Lingua::Poly::API::Users::Util qw(
	empty
	format_headers
	format_request_line
	format_response_line
);

use Moose;

has configuration => (is => 'ro', required => 1);
has database => (is => 'ro', required => 1);
has logger => (is => 'rw', required => 1);
has userService => (is => 'ro', required => 1);
has sessionService => (is => 'ro', required => 1);
has requestContextService => (
	isa => 'Lingua::Poly::API::Users::Service::RequestContext',
	is => 'ro',
	required => 1);
has tokenService => (
	isa => 'Lingua::Poly::API::Users::Service::Token',
	is => 'ro',
	required => 1,
);
has restService => (
	isa => 'Lingua::Poly::API::Users::Service::RESTClient',
	is => 'ro',
	required => 1,
);
has googleOAuthService => (
	isa => 'Lingua::Poly::API::Users::Service::OAuth::Google',
	is => 'ro',
	required => 1
);

sub startup {
	my ($self) = @_;

	$self->moniker('lingua-poly-service-um');

	$self->plugin('Util::RandomString');
	$self->plugin('RemoteAddr');

	$self->config($self->configuration);

	$self->plugin(OpenAPI => {
		spec => $self->static->file('openapi.yaml')->path,
		schema => 'v3',
		security => {
			cookieAuth => sub {
				my ($ctx, $definition, $scopes, $cb) = @_;

				my $session = $ctx->stash->{session};

				return $ctx->$cb('You are not logged in.') if !$session->user;

				return $ctx->$cb;
			}
		}
	});

	my $config = $self->config;
	$self->hook(before_dispatch => sub { $self->__beforeDispatch(@_) });
	$self->hook(after_dispatch => sub { $self->__afterDispatch(@_) });

	$self->info("application ready");
}

sub __beforeDispatch {
	my ($self, $ctx) = @_;

	$self->debug(format_request_line '<<<', $ctx->req);
	$self->debug(format_headers '<<<', $ctx->req->headers);

	$self->sessionService->maintain;

	my $fingerprint = $self->requestContextService->fingerprint($ctx);
	my $session_id = $self->requestContextService->sessionID($ctx);
	$ctx->stash->{session}
		= $self->sessionService->refreshOrCreate($session_id, $fingerprint);
}

sub __afterDispatch {
	my ($self, $ctx) = @_;

	my $session = $ctx->stash->{session};
	$self->requestContextService->sessionCookie($ctx, $session)
		if $session;

	# This must come last in the after_dispatch hook.
	$self->debug(format_response_line '>>>', $ctx->res);
	$self->debug(format_headers '>>>', $ctx->res->headers);

	$DB::single = 1;
}

1;
