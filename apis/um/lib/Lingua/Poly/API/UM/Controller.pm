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

package Lingua::Poly::API::UM::Controller;

use strict;

use HTTP::Status qw(:constants);
use Email::Sender::Transport::SMTP 1.300031;
use Mojo::URL;

use Mojo::Base ('Mojolicious::Controller', 'Lingua::Poly::API::UM::Logging');

# It would be better to use RFC7807 error responses but that may conflict
# with the response bodies generated by the OpenAPI plug-in.
sub errorResponse {
	my ($self, $code, @raw_errors) = @_;

    $code ||= HTTP_BAD_REQUEST;
	my @errors;
	foreach my $error (@raw_errors) {
		$error = { message => $error } if !ref $error;
		$error->{path} //= '/';
		push @errors, $error;
	}

	return $self->render(openapi => { errors => \@errors }, status => $code);
}

# FIXME! Inline where needed!
sub realm {
	my $realm = __PACKAGE__;
	$realm =~ s/::([^:]+::Controller::.*)/$1/;
}

sub logger {
	my ($self) = @_;

	return $self->{_logger} if exists $self->{_logger};
	my $app = $self->{_ctx}->app;

	# FIXME! Can we use the SmartLogger constructor here?
	return $self->{_logger} = $app->log->context('[FIXME! Controller base class!]');
}

sub fingerprint {
	my ($self) = @_;

	my $req = $self->req;

	my $ua = $req->headers->user_agent();
    $ua //= '';

    my $ip = $self->remote_addr;

    return join ':', $ip, $ua;
}

sub emailSenderTransport {
	return Email::Sender::Transport::SMTP->new(shift->config->{smtp});
}

sub siteURL {
	my ($self) = @_;

	my $req_url = $self->req->url->to_abs;
	my $url = Mojo::URL->new;
	$url->scheme($req_url->scheme);
	$url->host($req_url->host);
	$url->port($req_url->port);

	return $url;
}

1;
