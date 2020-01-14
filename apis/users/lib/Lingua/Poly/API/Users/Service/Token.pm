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

package Lingua::Poly::API::Users::Service::Token;

use strict;

use Moose;
use namespace::autoclean;

use Session::Token;
use base qw(Lingua::Poly::API::Users::Logging);

has logger => (is => 'ro');
has database => (is => 'ro');

sub create {
	my ($self, $purpose, $email) = @_;

	my $token = Session::Token->new(entropy => 256)->get;
	$self->database->execute(INSERT_TOKEN => $token, $purpose, $email);

	return $token;
}

sub delete {
	my ($self, $token) = @_;

	$self->database->execute(DELETE_TOKEN => $token);

	return $self;
}

sub byPurpose {
	my ($self, $purpose, $email) = @_;

	return $self->database->getRow(SELECT_TOKEN_BY_PURPOSE => $purpose, $email);
}

sub update {
	my ($self, $purpose, $email) = @_;

	$self->database->execute(UPDATE_TOKEN => $purpose, $email);

	return $self;
}

__PACKAGE__->meta->make_immutable;

1;
