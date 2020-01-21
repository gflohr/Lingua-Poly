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

package Lingua::Poly::API::Users::Controller::OauthGoogle;

use strict;

use HTTP::Status qw(:constants);

use Mojo::Base qw(Lingua::Poly::API::Users::Controller);

sub redirect {
	my $self = shift->openapi->valid_input or return;

	eval {
		my $params = $self->req->query_params->to_hash;
		my $session = $self->stash->{session};
		my $googleOauthService = $self->app->googleOAuthService;
		$googleOauthService->authenticate($self, %$params);
	};

	if ($@) {
		# FIXME! Redirect with error message?
		die $@;
	}

	die;
}

1;
