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
use Mojo::URL;

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
	$self->{session}->{remember} ||= 4 * 7 * 24 * 60 * 60;

	$self->{session}->{entropy} //= {};
	$self->{session}->{entropy}->{remember} = 256;

	$self->{prefix} = $args{apiPrefix};

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


	if (empty $self->{origin}) {
		delete $self->{origin};
		warn <<EOF;
$args{filename}:
Configuration variable "origin" missing.  Redirect URLs to this server will be
based on the value of the host header.  This is not recommended for production!

Try something like:

    origin: http://localhost:8080/

EOF
	} else {
		# Check and normalize the origin.
		my $origin = Mojo::URL->new($self->{origin});
		my $scheme = $origin->scheme;
		die "$args{filename}: origin must contain a scheme (e. g. 'https:')!\n"
			if empty $scheme;
		if ('https' ne $scheme && 'http' ne $scheme) {
			die "$args{filename}: origin must be an http or https URL!\n";
		}
		die "$args{filename}: origin must have a hostname!\n"
			if empty $origin->host;

		$self->{origin} = Mojo::URL->new;
		$self->{origin}->host($origin->host);
		$self->{origin}->scheme($origin->scheme);
		$self->{origin}->port($origin->port);
	}

	$self->{oauth} //= {};
	$self->{oauth}->{facebook} //= {};

	if (empty $self->{oauth}->{facebook}->{client_id}
	    || empty  $self->{oauth}->{facebook}->{client_secret}) {
		delete $self->{oauth}->{facebook}->{client_id};
		delete $self->{oauth}->{facebook}->{client_secret};
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
		delete $self->{oauth}->{google}->{client_id};
		delete $self->{oauth}->{google}->{client_secret};
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
