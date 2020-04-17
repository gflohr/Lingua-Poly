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

package Lingua::Poly::API::Users::Controller::Oauth;

use strict;

use HTTP::Status qw(:constants);

use Mojo::Base qw(Lingua::Poly::API::Users::Controller);
use Mojo::URL;

sub authorizationUrl {
	my $self = shift->openapi->valid_input or return;

	my $provider = $self->param('provider');

	my $url;
	if ('facebook' eq lc $provider) {
		$url = $self->app->facebookOAuthService->authorizationUrl($self);
	} elsif ('google' eq lc $provider) {
		$url = $self->app->googleOAuthService->authorizationUrl($self);
	}

	if (!defined $url) {
		return $self->errorResponse(HTTP_NOT_FOUND, 'Invalid or unsupported provider');
	}

	return $self->render(openapi => { href => $url });
}

1;
