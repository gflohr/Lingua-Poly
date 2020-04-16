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

package Lingua::Poly::API::Users::Service::Email;

use strict;

use Moose;
use namespace::autoclean;
use Email::Address 1.912;
use Email::Simple 2.216;
use Email::Sender::Simple 1.300031 qw(sendmail);
use Email::Sender::Transport::SMTP 1.300031;

use Lingua::Poly::API::Users::Util qw(empty);

use base qw(Lingua::Poly::API::Users::Logging);

has logger => (is => 'ro');
has configuration => (is => 'ro');

sub realm { 'email' }

sub parseAddress {
	my (undef, $email) = @_;

	my @addresses = Email::Address->parse($email);
	return if !@addresses;
	return if @addresses != 1;

	return lc $addresses[0]->address;
}

sub send {
	my ($self, %options) = @_;

	if (empty $options{to}) {
		require Carp;
		Carp::croak("no recipient");
	}
	if (empty $options{subject}) {
		require Carp;
		Carp::croak("empty subject");
	}
	if (empty $options{body}) {
		require Carp;
		Carp::croak("empty body");
	}

	my $config = $self->configuration;
	my $email = Email::Simple->create(
		header => [
			To => $options{to},
			From => $config->{smtp}->{sender},
			Subject => $options{subject},
		],
		body => $options{body},
	);

	my $transport = Email::Sender::Transport::SMTP->new($config->{smtp});
	sendmail $email, { transport => $transport };

	return $self;
}

__PACKAGE__->meta->make_immutable;

1;
