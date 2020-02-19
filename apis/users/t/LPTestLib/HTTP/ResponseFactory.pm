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

package LPTestLib::HTTP::ResponseFactory;

use strict;

use HTTP::Status qw(:constants status_message);
use HTTP::Response;
use JSON '-convert_blessed_universally';
use Scalar::Util qw(reftype);
use Mojo::Date;

sub new {
	my $self = '';
	bless \$self, shift;
}

sub json {
	my ($self, $data) = @_;

	my $type = reftype $data;
	if (!$type || ($type ne 'HASH' && $type ne 'ARRAY')) {
		require Carp;
		Carp::croak('JSON data must be array or hash reference');
	}

	my $content = JSON->new->convert_blessed->utf8->encode($data);
	my $content_length = scalar @{[unpack 'C*', $content]};

	return HTTP::Response->new(
		HTTP_OK,
		status_message(HTTP_OK),
		[
			Date => Mojo::Date->new->to_string,
			Expires => 'Thu, 01 Jan 1970 00:00:00 GMT',
			'Content-Type' => 'application/json; charset=UTF-8',
			Pragma => 'no-cache',
			'Cache-Control' => 'no-store',
			'Content-Length' => $content_length,
			'Strict-Transport-Security' => 'max-age=15552000; preload',
			'Access-Control-Allow-Origin' => '*',
			'Alt-Svc' => 'h3-24=":443"; ma=3600',
		],
		$content,
	);
}

1;

=head1 NAME

LPTestLib::HTTP::ResponseFactory - HTTP Response Factory

=head1 SYNOPSIS

	use lib 't';
	use LPTestLib::HTTP::ResponseFactory;

	$gen = HTTP::ResponseFactory->new;
	$r = $gen->json({
		Tom => 'foo',
		Dick => 'bar',
		Harry => 'baz',
	});

=head1 DESCRIPTION

The module B<LPTestLib::HTTP::ResponseFactory> can be used to generate
complete HTTP responses for testing purposes.

=head1 CONSTRUCTOR

=over 4

=item B<new>

The constructor takes no arguments.

=back

=head1 METHODS

=over 4

=item B<json DATA>

Returns an L<HTTP::Response> with B<DATA> encoded as JSON.  It is taken care
of that blessed objects can be passed in.

B<DATA> must either be a hash or array reference.

=back

=head1 SEE ALSO

L<HTTP::Response>(3pm), L<JSON>(3pm), perl(1)

=cut

