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

package Lingua::Poly::API::Users::Service::User;

use strict;

use Moose;
use namespace::autoclean;

use Lingua::Poly::API::Users::Util qw(crypt_password empty);
use Lingua::Poly::API::Users::Validator::Homepage;

use base qw(Lingua::Poly::API::Users::Logging);

has logger => (is => 'ro');
has database => (is => 'ro');
has emailService => (
	is => 'ro',
	isa => 'Lingua::Poly::API::Users::Service::Email',
	required => 1,
);

sub create {
	my ($self, $email, $password) = @_;

	my $db = $self->database;
	my $digest = empty $password ? undef : crypt_password $password;
	$db->execute(INSERT_USER => $email, $digest);

	return $db->lastInsertId('users');
}

sub userByUsernameOrEmail {
	my ($self, $id) = @_;

	my $db = $self->database;
	my $statement;
	if ($id =~ /@/) {
		# Normalize the address.
		$id = $self->emailService->parseAddress($id);
		return if !defined $id;
		$statement = 'SELECT_USER_BY_EMAIL',
	} else {
		$statement = 'SELECT_USER_BY_USERNAME',
	}

	my ($user_id, $username, $email, $password, $confirmed,
	    $homepage, $description) = $db->getRow(
		$statement => $id
	);
	return if !defined $user_id;

	return Lingua::Poly::API::Users::Model::User->new(
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

	return Lingua::Poly::API::Users::Model::User->new(
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
		$homepage = Lingua::Poly::API::Users::Validator::Homepage->new->check($homepage);
	}

	$self->database->execute(
		UPDATE_USER => $user->username, $homepage, $user->description, $user->id
	);
}

__PACKAGE__->meta->make_immutable;

1;
