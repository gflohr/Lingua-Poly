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

use Lingua::Poly::API::Users::Util qw(crypt_password empty equals);
use Lingua::Poly::API::Users::Validator::Homepage;

use base qw(Lingua::Poly::API::Users::Logging);

has configuration => (is => 'ro', required => 1);
has logger => (
	is => 'ro',
	isa => 'Lingua::Poly::API::Users::SmartLogger',
	required => 1,
);
has database => (
	is => 'ro',
	isa => 'Lingua::Poly::API::Users::Service::Database',
	required => 1,
);
has sessionService => (
	is => 'ro',
	isa => 'Lingua::Poly::API::Users::Service::Session',
	required => 1,
);
has emailService => (
	is => 'ro',
	isa => 'Lingua::Poly::API::Users::Service::Email',
	required => 1,
);

sub create {
	my ($self, $email, %options) = @_;

	my $db = $self->database;
	my $digest = empty $options{password}
		? undef : crypt_password $options{password};

	$options{confirmed} ||= 1;

	$db->execute(INSERT_USER
		=> $email, $digest,
		   $options{confirmed}, $options{externalId}, $options{provider});

	my $user_id = $db->lastInsertId('users');

	return Lingua::Poly::API::Users::Model::User->new(
		id => $user_id,
		email => $email,
		externalId => $options{externalId},
		provider => $options{provider},
		password => $options{password},
		confirmed => $options{confirmed},
	);
}

sub userByUsernameOrEmail {
	my ($self, $id) = @_;

	my $db = $self->database;
	my ($statement, @args);
	if ($id =~ /@/) {
		# Normalize the address.
		$id = $self->emailService->parseAddress($id);
		return if !defined $id;
		$statement = 'SELECT_USER_BY_EMAIL';
	} else {
		$statement = 'SELECT_USER_BY_USERNAME',
	}

	return $self->__userByStatement($statement, $id);
}

sub userByExternalId {
	my ($self, $provider, $id) = @_;

	return $self->__userByStatement(
		SELECT_USER_BY_EXTERNAL_ID => $provider, $id);
}

sub userByToken {
	my ($self, $purpose, $token) = @_;

	return $self->__userByStatement(SELECT_USER_BY_TOKEN =>  $purpose, $token);
}

sub __userByStatement {
	my ($self, $statement, @args) = @_;

	my $db = $self->database;
	my ($user_id, $username, $email, $external_id, $password, $confirmed,
	    $homepage, $description) = $db->getRow(
		$statement => @args
	);
	return if !defined $user_id;

	return Lingua::Poly::API::Users::Model::User->new(
		id => $user_id,
		username =>  $username,
		email => $email,
		externalId => $external_id,
		password => $password,
		confirmed => $confirmed,
		homepage => $homepage,
		description => $description,
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
	} elsif ($user->username =~ m{[/\@:]}) {
		die "username must not contain a slash or an at-sign or a colon.\n";
	}

	my $homepage = $user->homepage;
	if (empty $homepage) {
		undef $homepage;
	} else {
		$homepage = Lingua::Poly::API::Users::Validator::Homepage->new->check($homepage);
	}

	$self->database->execute(
		UPDATE_USER => $user->email, $user->externalId, $user->username,
		               $homepage, $user->description, $user->id
	);

	return $self;
}

sub deleteUser {
	my ($self, $user) = @_;

	$self->database->execute(DELETE_USER => $user->id);

	return $self;
}

sub login {
	my ($self, %args) = @_;

	my ($session, $external_id, $provider, $email, $access_token, $expires) =
		@args{qw(session externalId provider email accessToken expires)};

	$email = $self->emailService->parseAddress($email) if !empty $email;

	my $user;
	if (defined $provider) {
		$user = $self->userByExternalId($external_id, $provider);
	} else {
		die "not yet implemented";
	}

	my $user_by_email = $self->userByUsernameOrEmail($email) if !empty $email;

	if ($user) {
		if ($user_by_email && $user_by_email->id ne $user->id) {
			# We have to delete the conflicting user in the database and
			# merge the data.
			$user->merge($user_by_email);
			$self->deleteUser($user_by_email);
			$self->updateUser($user);
		}
	} elsif ($user_by_email) {
		# User had logged in before but in another way.
		$user = $user_by_email;
		if (!equals $user->externalId, $user_by_email->externalId) {
			$user->externalId($external_id);
		}
	} else {
		# New user.
		$user = $self->create($email,
			externalId => $external_id,
			provider => $provider,
			confirmed => 1,
		);
	}

	# Not else! Variable $user may have been assiged to!
	if ($user) {
		$session->user($user);
		$session->nonce(undef);
		$session->provider($provider);
		$session->token($access_token);
		$session->token_expires($expires);
		$self->sessionService->renew($session);
	}

	$self->database->commit;

	return Mojo::URL->new($self->configuration->{origin});
}

sub changePassword {
	my ($self, $user, $password) = @_;

	my $db = $self->database;

	my $digest = crypt_password $password;
	$db->execute(UPDATE_USER_PASSWORD => $digest, $user->id);
	$db->commit;

	$user->password($digest);

	return $self;
}

sub resetPassword {
	my ($self, $user_id) = @_;

	my $user = $self->userByUsernameOrEmail($user_id);
	return $self if !$user;

	die;
}

__PACKAGE__->meta->make_immutable;

1;
