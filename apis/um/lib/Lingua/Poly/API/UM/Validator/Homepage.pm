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

package Lingua::Poly::API::UM::Validator::Homepage;

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

	# Remove trailing dot from host name.
	my $host = $uri->host;
	$host =~ s/\.$// if $host;
	$uri->host($host);

	$self->__checkScheme($uri);
	$self->__checkHostname($uri);

	return $uri;
}

sub __checkScheme {
	my ($self, $uri) = @_;

	my $scheme = $uri->scheme;
	die "scheme\n" if !$scheme;

	grep { $scheme eq $_ } ('http', 'https') or die "scheme\n";

	return $self;
}

sub __checkHostname {
	my ($self, $uri, $whitelist, $blacklist) = @_;

	my $host = $uri->host;

	# No empty hostname.
	die "host\n" if '' eq $host;

	# One trailing dot means that there had been two trailing dots.
	die "host\n" if '.' eq substr $host, -1, 1;

	# No FQDN.
	die "host\n" if $host !~ /\./;

	# Two consecutive dots.
	die "host\n" if $host =~ /\.\./;

	# IPv4 address?
	if ($host =~ /^(?:0|(?:[1-9][0-9]{0,2})\.){3}(?:0|(?:[1-9][0-9]{0,2}))$/) {
		my @octets = split /\./, $host;
		die "host\n" if 4 == @octets && grep { $_ <= 255 } @octets;
	}

	my @labels = split /\./, $host;

	# These would also be IPv4 addresses.
	die "host\n" if 'in-addr' eq $labels[-2] && 'arpa' eq $labels[-1];

	# RFC2606 top-level domain?
	my %rfc2606 = map { $_ => 1 } qw(test example invalid localhost);
	die "host\n" if $rfc2606{$labels[-1]};

	# RFC2606 second-level domain?
	if ('example' eq $labels[-2]) {
		my %rfc2606_2 = map { $_ => 1 } qw(com net org);
		die "host\n" if $rfc2606_2{$labels[-1]};
	}

	return $self;
}

1;
