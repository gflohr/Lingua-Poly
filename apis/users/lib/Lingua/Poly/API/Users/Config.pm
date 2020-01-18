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

package Lingua::Poly::API::Users::Config;

use strict;

use YAML::XS;
use Session::Token 1.503;

use Lingua::Poly::API::Users::Util qw(empty);

sub new {
	my ($class, %args) = @_;

	local $YAML::XS::Boolean = "JSON::PP";

	my $self = YAML::XS::LoadFile($args{filename});
	if (!$self->{secrets} || !ref $self->{secrets}
	    || 'ARRAY' ne ref $self->{secrets}) {
		my $secret = Session::Token->new(entropy => 256)->get;

		die(<<EOF);

$args{filename}:
Configuration variable "secrets" missing.  Try:

secrets:
- $secret
EOF

		exit 1;
	}

	$self->{database} //= {};
	$self->{database}->{dbname} //= 'linguapoly';
	$self->{database}->{user} //= '';

	$self->{session} //= {};
	$self->{session}->{timeout} ||= 2 * 60 * 60;
	$self->{session}->{cookieName} //= 'id';

	if (empty $self->{prefix}) {
		my @all = split /::/, __PACKAGE__;
		pop @all;
		my @prefix;
		while (@all) {
			my $curr = pop @all;
			last if 'api' eq lc $curr;
			unshift @prefix, lc $curr;
		}
		$self->{prefix} = join '/', '', 'api', 'lingua-poly', @prefix, 'v1';
	}

	$self->{smtp} //= {};
	$self->{smtp}->{host} //= 'localhost';
	$self->{smtp}->{port} //= 1025;

	if (empty $self->{smtp}->{sender}) {
		die (<<EOF);

$args{filename}:
Configuration variable "smtp.sender" missing.  Try something like:

smtp:
  sender: Lingua::Poly <do_not_reply\@yourdomain.com>

Replace "yourdomain.com" with a suitable domain name.
EOF
	}

	$self->{oauth} //= {};
	$self->{oauth}->{facebook} //= {};

	if (empty $self->{oauth}->{facebook}->{client_id}
	    || empty  $self->{oauth}->{facebook}->{client_secret}) {
		warn <<EOF;

$args{filename}:
Configuration variable "oauth.facebook.client_id" respectively
"oauth.facebook.client_secret" missing.  The Login with Facebook will
not work.  If you have a facebook app for logging in, try:

oauth:
  facebook:
    client_id: CLIENT_ID
    client_secret: CLIENT_SECRET
EOF
	}

	$self->{oauth}->{google} //= {};

	if (empty $self->{oauth}->{google}->{client_id}
	    || empty  $self->{oauth}->{google}->{client_secret}) {
		warn <<EOF;

$args{filename}:
Configuration variable "oauth.google.client_id" respectively
"oauth.google.client_secret" missing.  The Login with Google OpenID Connect
will not work.  If you have a Google OAuth application, you  can try this:

oauth:
  google:
    client_id: CLIENT_ID
    client_secret: CLIENT_SECRET
EOF
	}

	bless $self, $class;
}

sub secret {
	shift->{secrets}->[0];
}

1;
