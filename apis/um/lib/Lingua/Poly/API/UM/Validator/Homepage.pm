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
use Encode;

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

	# What about user info? That is an embedded username and password.  While
	# it seems to be a little bit odd to publish such a URL on the internet,
	# we do not have to prevent every possible way that users might shoot
	# themselves in the foot.  So we just allow them.

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
	die "host\n" if !defined $host;
	die "host\n" if '' eq $host;

	# RFC-952 states:
	#
	# > Host software MUST handle host names of up to 63 characters and
	# > SHOULD handle host names of up to 255 characters.
	#
	# That means that host software is free to support longer names, and we
	# therefore do not count the length of the hostname here.

	# Forbidden characters.
	die "host($1)\n" if $host =~ /([\x00-\x2d\x2f\x3a-\x60\x7b-\xff])/;

	# Actually there are a lot of restrictions for using Unicode characters
	# but they are tld specific.  We just check for a valid utf-8 input here.
	Encode::_utf8_off($host);
	$host = Encode::decode('UTF-8', $host, Encode::FB_CROAK);

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

	# There is no need to check for IPv6 addresses because they cannot contain
	# a dot.

	my @labels = split /\./, $host;

	# We disallow .arpa altogether because '.in-addr.arpa' are IPv4 addresses
	# (which are not allowed), '.ip6.arpa' are  IPv6 addresses (also not
	# allowed) and '.home.arpa' are private networks.  And we simply assume
	# that the rest is phased out or does not make sense for us.
	die "host\n" if 'arpa' eq $labels[-1];

	# RFC2606 top-level domain?
	my %rfc2606 = map { $_ => 1 } qw(test example invalid localhost);
	die "host\n" if $rfc2606{$labels[-1]};

	# RFC2606 second-level domain?
	if ('example' eq $labels[-2]) {
		my %rfc2606_2 = map { $_ => 1 } qw(com net org);
		die "host\n" if $rfc2606_2{$labels[-1]};
	}

	# A hyphen is not allowed as the first or last character of a label.
	die "host\n" if grep { /^-/ } @labels;
	die "host\n" if grep { /-$/ } @labels;

	# Many tld registries do not allow the registration of 2nd level
	# subdomains (for example .uk) or certain 2nd level subdomains have
	# special purposes and cannot be registered (for example .b.br for
	# Brasilian banks).  This could only be checked with a lookup table that
	# has to be maintained.  Such homepage can simply not be resolved which
	# is considered a minor problem.

	return $self;
}

1;
