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

use base qw(Exporter);

our @EXPORT_OK = qw(empty crypt_password check_password
                    format_headers format_request_line format_response_line);

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

1;

