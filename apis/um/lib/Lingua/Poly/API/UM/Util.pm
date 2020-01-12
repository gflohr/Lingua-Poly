#! /bin/false
#
# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018-2019 Guido Flohr <guido.flohr@cantanea.com>
#               All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package Lingua::Poly::API::UM::Util;

use strict;

use Password::OWASP::Argon2;
use List::Util qw(max);

use base qw(Exporter);

our @EXPORT_OK = qw(
	empty crypt_password check_password
	format_headers format_request_line format_response_line
	parse_ipv4
);

sub empty($) {
    return if defined $_[0] && length $_[0];

    return 1;
}

sub crypt_password($) {
	return Password::OWASP::Argon2->new->crypt_password(shift);
}

sub check_password($$) {
	my ($cleartext, $digest) = @_;

	return Password::OWASP::Argon2->new->check_password($cleartext, $digest);
}

sub format_headers($$) {
	my ($prefix, $headers) = @_;

	my @headers;
	foreach my $name (sort @{$headers->names}) {
		push @headers, "$prefix $name: " . $headers->header($name);
	}

	return @headers
}

sub format_request_line($$) {
	my ($prefix, $req) = @_;

	my $method = $req->method;
	my $url = $req->url;
	my $version =  $req->version;

	return "$prefix $method $url HTTP/$version";
}

sub format_response_line($$) {
	my ($prefix, $res) = @_;

	my $version =  $res->version;
	my $code = $res->code;
	my $msg = $res->message || $res->default_message;

	return "$prefix HTTP/$version $code $msg";
}

# Parses an IPv4 decimal address (already split up at the dots) into four
# integers in the range of 0-255 or returns false.
sub parse_ipv4 {
	my (@labels) = @_;

	return if @labels < 1;
	return if @labels > 4;

	# Parse the individual numerical labels into groups.  Mac OS X does not
	# detect 32 bit overflows in the numbers, GNU libc does.  In other words,
	# on the mac, the address 999999999999 is equivalent to 212.165.15.255
	# while on Linux it is invalid.  Actually, Mac OS X allows arbitrarily large
	# numbers.
	#
	# We follow the GNU libc approach here because it looks more consistent.
	my @parts;
	foreach my $label (@labels) {
		if ($label =~ /^0[0-7]*$/) {
			# Octal number.  Make sure it fits into 32 bits.
			$label =~ s/^0*/0/;
			$label = '0' if !$label;
			my $l = length $label;
			return if 12 < $l;
			return if 12 == $l && $label gt '037777777777';
			push @parts, oct $label;
		} elsif ($label =~ s/^0[xX]([0-9a-f]*)$/$1/) {
			# Hexadecimal number.  Make sure it fits into 32 bits.
			$label =~ s/^0*/0/;
			return if 8 < length $label;
			push @parts, oct "0x$label";
		} elsif ($label =~ /^[0-9]+$/) {
			# Decimal number. Make sure, it fits into 32 bits.
			$label =~ s/^0+//;
			$label = '0' if !$label;
			my $l = length $label;
			return if 10 < $l;
			return if 10 == $l && $label gt '4294967296';
			push @parts, $label;
		} else {
			return;
		}
	}

	if (4 == @parts) {
		# x.x.x.x with 8.8.8.8 bits.
		return if 0xff < max @parts;
	} elsif (3 == @parts) {
		# x.x.x with 8.8.16 bits.
		return if $parts[0] > 0xff || $parts[1] > 0xff;
		return if $parts[2] > 0xffff;
		$parts[3] = $parts[2] & 0xff;
		$parts[2] >>= 8;
	} elsif (2 == @parts) {
		# x.x with 8.24 bits.
		return if $parts[0] > 0xff;
		return if $parts[0] > 0xffffff;
		$parts[3] = $parts[1] & 0xff;
		$parts[2] = $parts[1] >> 8 & 0xff;
		$parts[1] >>= 16;
	} else {
		# We already checked for overflows.
		$parts[3] = $parts[0] & 0xff;
		$parts[2] = $parts[0] >> 8 & 0xff;
		$parts[1] = $parts[0] >> 16 & 0xff;
		$parts[0] >>= 24;
	}

	return @parts;
}

1;

