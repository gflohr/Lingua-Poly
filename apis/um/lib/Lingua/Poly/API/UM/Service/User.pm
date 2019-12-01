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

package Lingua::Poly::API::UM::Service::User;

use strict;

use Moose;
use namespace::autoclean;

use base qw(Lingua::Poly::API::UM::Logging);

has logger => (is => 'ro');
has database => (is => 'ro');

sub userByUsernameOrEmail {
	my ($self, $id) = @_;

	my $db = $self->database;
	my $statement = $id =~ /@/ ?
		'SELECT_USER_BY_EMAIL' : 'SELECT_USER_BY_USERNAME';

	my ($user_id, $username, $email, $password, $confirmed) = $db->getRow(
		$statement => $id
	);
	return if !defined $user_id;

	return Lingua::Poly::API::UM::Model::User->new(
		username =>  $username,
		email => $email,
		password => $password,
		confirmed => $confirmed,
	);
}

__PACKAGE__->meta->make_immutable;

1;
