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

package Lingua::Poly::API::UM::Model::User;

use strict;

use Moose;
use namespace::autoclean;

has id => (isa => 'Int', is => 'ro');
has username => (isa => 'Maybe[Str]', is => 'ro');
has email => (isa => 'Maybe[Str]', is => 'ro');
has password => (isa => 'Str', is => 'ro');
has confirmed => (isa => 'Bool', is => 'ro');

use Lingua::Poly::API::UM::Util qw(empty);

sub toResponse {
	my ($self) = @_;

	my %user;
	$user{username} = $self->username if !empty $self->username;
	$user{email} = $self->email if !empty $self->email;

	return %user;
}

__PACKAGE__->meta->make_immutable;

1;

