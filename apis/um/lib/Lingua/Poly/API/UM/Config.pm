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

package Lingua::Poly::API::UM::Config;

use strict;

use YAML::XS;
use Session::Token 1.503;

use Lingua::Poly::API::UM::Util qw(empty);

sub new {
	my ($class, %args) = @_;

	local $YAML::XS::Boolean = "JSON::PP";

	my $self = YAML::XS::LoadFile($args{filename});
	if (!$self->{secrets} || !ref $self->{secrets}
	    || 'ARRAY' ne ref $self->{secrets}) {
		my $secret = Session::Token->new(entropy => 256)->get;

		die(<<EOF);

$args{filename}:
configuration variable "secrets" missing.  Try:

secrets:
- $secret
EOF

		exit 1;
	}

	$self->{database} //= {};
	$self->{database}->{dbname} //= 'lingua-poly-um';
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
configuration variable "smtp.sender" missing.  Try something like:

smtp:
  sender: Lingua::Poly <do_not_reply\@yourdomain.com>

Replace "yourdomain.com" with a suitable domain name.
EOF
	}

	bless $self, $class;
}

1;
