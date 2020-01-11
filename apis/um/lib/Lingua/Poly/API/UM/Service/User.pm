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

use Lingua::Poly::API::UM::Util qw(crypt_password empty);
use Lingua::Poly::API::UM::Validator::Homepage;

use base qw(Lingua::Poly::API::UM::Logging);

has logger => (is => 'ro');
has database => (is => 'ro');

sub create {
	my ($self, $email, $password) = @_;

	my $db = $self->database;
	$db->execute(INSERT_USER => $email, crypt_password $password);

	return $db->lastInsertId('users');
}

sub userByUsernameOrEmail {
	my ($self, $id) = @_;

	my $db = $self->database;
	my $statement = $id =~ /@/ ?
		'SELECT_USER_BY_EMAIL' : 'SELECT_USER_BY_USERNAME';

	my ($user_id, $username, $email, $password, $confirmed,
	    $homepage, $description) = $db->getRow(
		$statement => $id
	);
	return if !defined $user_id;

	return Lingua::Poly::API::UM::Model::User->new(
		id => $user_id,
		username =>  $username,
		email => $email,
		password => $password,
		confirmed => $confirmed,
		homepage => $homepage,
		description => $description,
	);
}

sub byToken {
	my ($self, $purpose, $token) = @_;

	my $db = $self->database;
	my ($user_id, $username,  $email, $password, $confirmed) = $db->getRow(
		SELECT_TOKEN => $purpose, $token);
	return if !defined $user_id;

	return Lingua::Poly::API::UM::Model::User->new(
		id => $user_id,
		username =>  $username,
		email => $email,
		password => $password,
		confirmed => $confirmed,
	);
}

sub activate {
	my ($self, $user) = @_;

	$self->database->execute(UPDATE_USER_ACTIVATE => $user->id);

	return $self;
}

sub updateUser {
	my ($self, $user) = @_;

	# The RDBMS checks the uniqueness of the username.

	if (!length $user->username) {
		$user->username(undef);
	} elsif ($user->username =~ m{[/@]}) {
		die "username must not contain a slash or an at-sign.\n";
	}

	my $homepage = $user->homepage;
	if (empty $homepage) {
		undef $homepage;
	} else {
		$homepage = Lingua::Poly::API::UM::Validator::Homepage->new->check($homepage);
	}

	$self->database->execute(
		UPDATE_USER => $user->username, $homepage, $user->description, $user->id
	);
}

__PACKAGE__->meta->make_immutable;

1;
