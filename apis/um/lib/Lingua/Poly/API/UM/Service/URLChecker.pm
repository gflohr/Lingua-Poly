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

	my $uri = URI->new($url)->canonical;

	$self->__checkScheme(
		$uri,
		$options{scheme_whitelist},
		$options{scheme_blacklist},
	);

	$self->__checkHostname(
		$uri,
		$options{host_whitelist},
		$options{host_blacklist},
	);

	return $self;
}

sub __checkScheme {
	my ($self, $uri, $whitelist, $blacklist) = @_;

	my $subject = $uri->scheme or '';

	if ($whitelist) {
		grep { $subject eq $_ || '*' eq $_ }
		map { lc $_ } @$whitelist
		and return $self;
	}

	if ($blacklist) {
		grep { $subject eq $_ || '*' eq $_ }
		map { lc $_ } @$blacklist
		and die "scheme\n";
	}

	return $self;
}

sub __checkHostname {
	my ($self, $uri, $whitelist, $blacklist) = @_;

	my $subject = $uri->host or '';

	my $match = sub {
		my ($subject, $listvalue) = @_;

		if ('*' eq $listvalue) {
			return 1;
		} elsif ($listvalue =~ s/^\*\.(.)/$1/) {
			my $l = length $listvalue;
			$subject = substr $subject, -$l, $l;

			return $subject eq $listvalue;
		}

		return $subject eq $listvalue;
	};

	if ($whitelist) {
		grep { $match->($subject, $_) }
		map { lc $_ } @$whitelist
		and return $self;
	}

	if ($blacklist) {
		grep { $match->($subject, $_) }
		map { lc $_ } @$blacklist
		and die "host\n";
	}

	return $self;
}

1;
