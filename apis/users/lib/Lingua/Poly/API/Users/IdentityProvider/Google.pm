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

package Lingua::Poly::API::Users::IdentityProvider::Google;

use strict;

use Moose;
use namespace::autoclean;

use Lingua::Poly::API::Users::Util qw(check_password);

use base qw(Lingua::Poly::API::Users::IdentityProvider::Local);

sub authenticate {
	require Carp;
	Carp::croak("Indentity provider Google cannot authenticate");
}

sub signOut {
	my ($self) = @_;


	my $context = $self->context;
	my $app = $context->app;
	my $session = $context->stash->{session};
	my ($token, $token_expires) = ($session->token, $session->token_expires);
	$self->SUPER::signOut();

	$app->googleOAuthService->revoke($token, $token_expires);

	return $self;
}

__PACKAGE__->meta->make_immutable;

1;

