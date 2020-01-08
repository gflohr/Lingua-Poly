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

sub new {
	my ($class) = @_;

	my $self = '';

	bless \$self, $class;
}

sub check {
	my ($self, $url) = @_;

	my $uri = URI->new($url)->canonical;

	$self->__checkScheme($uri);
	$self->__checkPort($uri);
	$self->__checkUserinfo($uri);
	my $host = $self->__checkHostname($uri);
	$uri->host($host);

	return $uri;
}

sub __checkScheme {
	my ($self, $uri) = @_;

	my $scheme = $uri->scheme;
	die "scheme\n" if !$scheme;

	grep { $scheme eq $_ } ('http', 'https') or die "scheme\n";

	return $self;
}

sub __checkPort {
	my ($self, $uri) = @_;

	# IMHO, URI should check that the port number is not out of range but it
	# does not.
	my $port = $uri->port;
	die "port\n" if $port < 1 || $port > 65535;

	return $self;
}

sub __checkUserinfo {
	my ($self, $uri) = @_;

	die "userinfo\n" if $uri->userinfo;

	return $self;
}

sub __checkHostname {
	my ($self, $uri) = @_;

	my $host = $uri->host;

	# No empty hostname.
	die "host\n" if !defined $host;
	die "host\n" if '' eq $host;

	# Discard an empty root label.
	$host =~ s/\.$//;

	# Two or more trailing dots.
	die "host\n" if $host =~ /\.$/;

	my @labels = split /\./, $host;

	# Disallow other empty labels.
	die "host\n" if grep { $_ eq '' } @labels;

	# The URI module does not canonicalize quad-dotted notation of IPv4
	# addresses if they are in octal or hexadecimal form.
	my $is_ip;
	if (@labels == 4) {
		my @octets;
		foreach my $label (@labels) {
			if ($label =~ /^(0)[0-7]+$/ || $label =~ /^(0x)[0-9a-f]+$/
			    || $label =~ /^(?:0|[1-9][0-9]*)$/) {
				my $octet = defined $1 ? oct $label : $label;
				last if $octet > 255;
				push @octets, $octet;
			}
		}

		if (4 == @octets) {
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
		}
	} elsif ($uri =~ /^https?:\/\/\[([0-9a-fA-F:]+)\](:(?:0|[1-9][0-9]*))?(\/|\Z)/ && $host =~ /:/) {
		# Uncompress the IPv6 address.
		my @groups = split /:/, $host;
		if (@groups < 7) {
			for (my $i = 0; $i < @groups; ++$i) {
				if ($groups[$i] eq '') {
					$groups[$i] = 0;
					my $missing = 7 - @groups;
					@groups = splice @groups, $i, 0, '0' x $missing;
				}
				last;
			}
		}

		my $max = max map { hex } @groups;
		if ($max <= 0xffff) {
			$is_ip = 1;
			my $norm = join ':', map { sprintf '%04s' } @groups;
			if ($max == 0 # the unspecified address
				    # Loopback.
				    || '0000:0000:0000:0000:0000:00000:0000:0001' eq $norm
				    # Discard prefix.
				    || $norm =~ /^0100/
				    # Teredo tunneling, ORCHIDv2, documentation, 6to4.
				    || $norm =~ /^2[12]00/
				    # Private networks.
				    || $norm =~ /^fc[cd]/
				    # Link-local.
				    || $norm =~ /^fe[89ab]/
				    # Multicast.
				    || $norm =~ /^ff00/
				) {
					die "ipv6_special\n";
				}
		}
	}

	return $host if $is_ip;

	die "no_fqdn\n" if @labels < 2;

	# The top-level domain name must not contain a hyphen or digit unless it
	# is an IDN.
	my $tld = $labels[-1];
	if (('xn--' ne substr $tld, 0, 4) && ($tld =~ /[-0-9]/)) {
		die "invalid_tld\n";
	}

	# RFC2606 top-level domain? We also disallow .arpa and .int altogether.
	my %rfc2606 = map { $_ => 1 } qw(test example invalid localhost arpa int);
	die "host\n" if $rfc2606{$labels[-1]};

	# RFC2606 second-level domain?
	if ('example' eq $labels[-2]) {
		my %rfc2606_2 = map { $_ => 1 } qw(com net org);
		die "host\n" if $rfc2606_2{$labels[-1]};
	}

	# Some people say that a top-level domain must be at least two characters
	# long.  But there is no evidence for that.

	# Misplaced hyphen.
	foreach my $label (@labels) {
		if ($label =~ /^-/ || $label =~ /-$/) {
			die "label:hyphen\n";
		}
	}

	# Unicode.  We allow all characters except the forbidden ones in the
	# ASCII range.
	if ($host =~ /([\x00-\x2c\x2f\x3a-\x60\x7b-\x7f])/) {
		die "label:forbidden_char($1)n";
	}

	return $host;
}

1;
