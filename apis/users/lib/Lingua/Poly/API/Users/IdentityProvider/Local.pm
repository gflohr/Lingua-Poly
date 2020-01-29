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

package Lingua::Poly::API::Users::IdentityProvider::Local;

use strict;

use Moose;
use namespace::autoclean;

use base qw(Lingua::Poly::API::Users::Logging);

has context => (
	is => 'ro',
	required => 1,
	isa => 'Mojolicious::Controller',
);

sub realm { 'authentication' }

sub authenticate {
	my ($self, $payload) = @_;

	my $app = $self->context->app;

	my $db = $app->database;

	$self->info("user '$login_data->{id}' trying to log in");

	my $user = $app->userService->userByUsernameOrEmail($login_data->{id});
	if (!$user || !$user->confirmed) {
		if (!$user) {
			$self->debug("user '$login_data->{id}' is unknown");
		} elsif (!$user->confirmed) {
			$self->debug("user '$login_data->{id}' is unconfirmed");
		}
		return;
	}

	if (!check_password $login_data->{password}, $user->password) {
		$self->debug("user '$login_data->{id}': invalid credentials");
		return;
	}

	return $user;
}

__PACKAGE__->meta->make_immutable;

1;

