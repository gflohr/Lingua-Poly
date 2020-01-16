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

package Lingua::Poly::API::Users::Service::Session;

use strict;

use Moose;
use namespace::autoclean;

use Session::Token;

use Lingua::Poly::API::Users::Model::User;
use Lingua::Poly::API::Users::Model::Session;

use base qw(Lingua::Poly::API::Users::Logging);

has logger => (is => 'ro');
has database => (is => 'ro');
has configuration => (is => 'ro');
has userService => (is => 'ro');

my $last_cleanup = 0;

sub realm { 'session' }

sub maintain {
	my ($self) = @_;

	# Clean-up at most once per second.
	my $now = time;
	return $self if $now <= $last_cleanup;

	$self->info('doing maintainance');

	my $config = $self->configuration;

	$last_cleanup = $now;
	$self->database->transaction(
		[ DELETE_USER_STALE => $config->{session}->{timeout} ],
		[ DELETE_SESSION_STALE => $config->{session}->{timeout} ],
		[ DELETE_TOKEN_STALE => $config->{session}->{timeout} ],
	);

	return $self;
}

sub refreshOrCreate {
	my ($self, $sid, $fingerprint) = @_;

	my ($user_id, $username, $email, $password, $confirmed,
	    $homepage, $description);
	my $database = $self->database;

	my ($provider, $token);

	if (defined $sid && (($user_id, $provider, $token) = $database->getRow(
			SELECT_SESSION => $sid, $fingerprint
		))) {
		$self->debug('updating session');
		$database->execute(UPDATE_SESSION => $sid);
		if (defined $user_id) {
			($username, $email, $password, $confirmed,
			 $homepage, $description) = $database->getRow(
				SELECT_USER_BY_ID => $user_id
			);
			if ((!defined $username && !defined $email) || !$confirmed) {
				$self->debug("updating anonymous session");
				undef $user_id;
			} else {
				$self->debug("updating session for user id '$user_id'");
			}
		}
	} else {
		$provider = 'local';
		$self->debug('creating fresh session');
		$sid = Session::Token->new(entropy => 256)->get;
		$database->execute(INSERT_SESSION => $sid, $fingerprint, $provider);
	}

	$database->commit;

	my %args = (sid => $sid, provider => $provider, token => $token);
	if (defined $user_id) {
		$args{user} = Lingua::Poly::API::Users::Model::User->new(
			id => $user_id,
			username => $username,
			email => $email,
			password => $password,
			confirmed => $confirmed,
			homepage => $homepage,
			description => $description,
		);
	}
	return Lingua::Poly::API::Users::Model::Session->new(%args);
}

sub renew {
	my ($self, $session) = @_;

	my $sid = Session::Token->new(entropy => 256)->get;
	my $user = $session->user;
	my $user_id = $user ? $user-> id : undef;
	# FIXME! It is safer to first delete the old session, and create
	# a new one.  Otherwise there might be a race with the auto-cleanup.
	$self->database->execute(
		UPDATE_SESSION_SID
		=> $sid, $user_id, $session->provider, $session->token, $session->sid);
	$session->sid($sid);

	return $self;
}

sub delete {
	my ($self, $session) = @_;

	$self->database->execute(DELETE_SESSION => $session->sid);

	return $self;
}

__PACKAGE__->meta->make_immutable;

1;
