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
use List::Util qw(max);

use Lingua::Poly::API::UM::Util qw(parse_ipv4);

sub new {
	my ($class) = @_;

	my $self = '';

	bless \$self, $class;
}

sub __uncompressIPv6($) {
	my ($host) = @_;

	my @groups = split /:/, $host;
	@groups = ('') if !@groups;
	if (@groups < 8) {
		for (my $i = 0; $i < @groups; ++$i) {
			if ($groups[$i] eq '') {
				splice @groups, $i, 1 while @groups > $i && '' eq $groups[$i];
				my $missing = 8 - @groups;
				splice @groups, $i, 0, ('0') x $missing;
				last;
			}
		}
	}

	return if @groups != 8;
	return if grep { !length } @groups;

	return @groups;
}

sub check {
	my ($self, $url) = @_;

	my $uri = URI->new($url)->canonical;

	$uri = $self->__checkScheme($uri);
	$uri = $self->__checkPort($uri);
	$uri = $self->__checkUserinfo($uri);
	$uri = $self->__checkHostname($uri);

	return $uri;
}

sub __checkScheme {
	my ($self, $uri) = @_;

	my $scheme = $uri->scheme;
	die "scheme\n" if !$scheme;

	grep { $scheme eq $_ } ('http', 'https') or die "scheme\n";

	return $uri;
}

sub __checkPort {
	my ($self, $uri) = @_;

	# IMHO, URI should check that the port number is not out of range but it
	# does not.
	my $port = $uri->port;

	# IMHO, URI should do that ....
	$uri->port($port) if $port =~ s/^0+//;

	die "port\n" if $port < 1 || $port > 65535;

	return $uri;
}

sub __checkUserinfo {
	my ($self, $uri) = @_;

	die "userinfo\n" if $uri->userinfo;

	return $uri;
}

sub __checkHostname {
	my ($self, $uri) = @_;

	my $host = $uri->host;

	# No empty hostname.
	die "host\n" if !defined $host;
	die "host\n" if '' eq $host;

	die "host\n" if $host =~ /\.\./;

	# Discard an empty root label.
	$host =~ s/\.$//;

	my @labels = split /\./, $host;

	# Disallow empty labels.
	die "host\n" if $uri->host =~ /\.\./;

	# The URI module does not canonicalize numerical IPv4 addresses.
	my @octets = parse_ipv4 @labels;
	my $is_ip;
	if (@octets) {
		$is_ip = 1;

		# IPv4 addresses with special purpose?
		if (# Loopback.
			$octets[0] == 127
			# Private IP ranges.
			|| $octets[0] == 10
			|| ($octets[0] == 172 && $octets[1] >= 16 && $octets[1] <= 31)
			|| ($octets[0] == 192 && $octets[1] == 168)
			# Carrier-grade NAT deployment.
			|| ($octets[0] == 100 && $octets[1] >= 64 && $octets[1] <= 127)
			# Link-local addresses.
			|| ($octets[0] == 169 && $octets[1] == 254)) {
			die "ipv4_special\n";
		}
		$host = join '.', @octets;
	} elsif ($host =~ /^[0-9a-f:]+$/ && ($host =~ y/:/:/ >= 2)) {
		# Uncompress the IPv6 address.
		my @groups = __uncompressIPv6 $host;
		my $max = max map { hex } @groups;
		if (@groups == 8 && $max <= 0xffff) {
			my $norm = join ':', map { sprintf '%04s', $_ } @groups;
			$is_ip = $norm =~ /^(?:[0-9a-f]{4}:){7}[0-9a-f]{4}$/;
			if ($is_ip
			    && ($max == 0 # the unspecified address
				    # Loopback.
				    || '0000:0000:0000:0000:0000:0000:0000:0001' eq $norm
				    # IPv4 mapped addresses.
				    || $norm =~ /^0000:0000:0000:0000:0000:ffff/
				    # IPv4 translated addresses.
				    || $norm =~ /^0000:0000:0000:0000:ffff:0000/
				    # IPv4/IPv6 address translation.
				    || $norm =~ /^0064:ff9b:0000:0000:0000:0000/
				    # IPv4 compatible.
					|| $norm =~ /^0000:0000:0000:0000:0000:0000/
				    # Discard prefix.
				    || $norm =~ /^0100/
				    # Teredo tunneling, ORCHIDv2, documentation, 6to4.
				    || $norm =~ /^200[12]/
				    # Private networks.
				    || $norm =~ /^f[cd]/
				    # Link-local.
				    || $norm =~ /^fe[89ab]/
				    # Multicast.
				    || $norm =~ /^ff/
					)
				) {
				die "ipv6_special\n";
			}

			# FIXME! Compress the address into its canonical form.
		}
	}

	if (!$is_ip) {
		die "no_fqdn\n" if @labels < 2;

		# The top-level domain name must not contain a hyphen or digit unless it
		# is an IDN.
		my $tld = $labels[-1];
		if (('xn--' ne substr $tld, 0, 4) && ($tld =~ /[-0-9]/)) {
			die "invalid_tld\n";
		}

		# Special purpose top-level domain? We also disallow .arpa and .int
		# altogether.  Both .home and .corp are not registered but recommended for
		# private use (see for example  https://support.apple.com/en-us/HT207511).
		my %special_tld = map {
			$_ => 1
		} qw(
			test
			example
			invalid
			localhost
			local
			onion
			arpa
			int
			home
			corp
		);
		die "host\n" if $special_tld{$labels[-1]};

		# RFC2606 second-level domain?
		if ('example' eq $labels[-2]) {
			my %rfc2606_2 = map { $_ => 1 } qw(com net org);
			die "host\n" if $rfc2606_2{$labels[-1]};
		}

		# Some people say that a top-level domain must be at least two characters
		# long.  But there is no evidence for that.

		# Leading hyphens or digits, and trailing hyphens are not allowed.
		foreach my $label (@labels) {
			if ($label =~ /^[-0-9]/ || $label =~ /-$/) {
				die "label:hyphen\n";
			}
		}

		# Unicode.  We allow all characters except the forbidden ones in the
		# ASCII range.
		if ($host =~ /([\x00-\x2c\x2f\x3a-\x60\x7b-\x7f])/) {
			die "label:forbidden_char($1)n";
		}
	}

	$uri->host($host);

	return $uri;
}

1;
