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

package Lingua::Poly::API::Users::Model::User;

use strict;

use Moose;
use namespace::autoclean;

use Lingua::Poly::API::Users::Util qw(empty);

has id => (isa => 'Int', is => 'ro', required => 1);
has username => (isa => 'Maybe[Str]', is => 'rw');
has email => (isa => 'Maybe[Str]', is => 'rw');
has externalId => (isa => 'Maybe[Str]', is => 'rw');
has password => (isa => 'Maybe[Str]', is => 'rw');
has confirmed => (isa => 'Bool', is => 'rw');
has homepage => (isa => 'Maybe[Str]', is => 'rw');
has description => (isa => 'Maybe[Str]', is => 'rw');

use Lingua::Poly::API::Users::Util qw(empty);

sub toResponse {
	my ($self, $myself) = @_;

	my %user;
	$user{username} = $self->username if !empty $self->username;
	if ($myself) {
		$user{email} = $self->email if !empty $self->email;
	}
	$user{homepage} = $self->homepage if !empty $self->homepage;
	$user{description} = $self->description if !empty $self->description;

	return %user;
}

sub merge {
	my ($self, $other) = @_;

	foreach my $property (qw (username email externalId password confirmed
	                          homepage description)) {
		$self->$property($other->$property) if empty $self->$property;
	}

	return $self;
}

__PACKAGE__->meta->make_immutable;

1;

