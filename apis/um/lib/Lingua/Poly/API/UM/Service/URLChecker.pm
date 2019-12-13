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

package Lingua::Poly::API::UM::Service::URLChecker;

use strict;

use URI;

sub new {
	my ($class) = @_;

	my $self = '';

	bless \$self, $class;
}

sub check {
	my ($self, $url, %options) = @_;

	my $uri = URI->new($url);

	$self->__checkSchemes($uri, $options{schemes}) if $options{schemes};

	return $self;
}

sub __checkSchemes {
	my ($self, $uri, $schemes) = @_;

	my $scheme = $uri->scheme or '';

	grep { $_ eq $scheme} @$schemes
		or die "$scheme is not an allowed schema";
}

1;
