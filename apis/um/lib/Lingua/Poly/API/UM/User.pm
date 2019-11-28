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

package Lingua::Poly::API::UM::User;

use strict;

sub new {
	my ($class, $db, $name, $unconfirmed) = @_;

	my $statement = $name =~ /\@/ ?
		'SELECT_USER_BY_EMAIL' : 'SELECT_USER_BY_USERNAME';

	my @row = $db->getRow($statement => $name) or return;
	my ($id, $username, $email, $password, $confirmed) = @row;

	return if !$confirmed && !$unconfirmed;

	bless {
		__id => $id,
		__username => $username,
		__email => $email,
		__password => $password,
		__confirmed => $confirmed,
	}, $class;
}

sub newBySessionID {
	my ($class, $session_id) = @_;


}

sub id { shift->{__id} }

sub username { shift->{__username} }

sub email { shift->{__email} }

sub password { shift->{__password} }

sub confirmed { shift->{__confirmed} }

1;

