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

package Lingua::Poly::API::Users::Controller::Config;

use strict;

use HTTP::Status qw(:constants);

use Lingua::Poly::API::Users::Util qw(empty crypt_password);

use Mojo::Base qw(Lingua::Poly::API::Users::Controller);

sub get {
	my $self = shift->openapi->valid_input or return;

	my $api_config = $self->app->configuration;

	my $google_oauth_service = $self->app->googleOAuthService;
	my $google_auth_url = $self->app->googleOAuthService->authorizationUrl(
		$self);

	my %config;
	$config{googleAuthorizationUrl} = $google_auth_url
		if !empty $google_auth_url;
	$config{facebookAuthorizationUrl} = 'FIXME!';

	return $self->render(openapi => \%config, status => HTTP_OK);
}

1;
