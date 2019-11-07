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

package Lingua::Poly::RestAPI::Controller::User;

use strict;

use Time::HiRes qw(gettimeofday);
use YAML;
use Plack::Request;
use Plack::Response;
use HTTP::Status qw(:constants);
use Locale::TextDomain qw(Lingua-Poly);
use Locale::Messages qw(turn_utf_8_off);
use CGI::Cookie;
use Data::Password::zxcvbn qw(password_strength);

use Lingua::Poly::RestAPI::Logger;

use Mojo::Base "Lingua::Poly::RestAPI::Controller";

sub realm { "user" }

sub create {
	my $self = shift->openapi->valid_input or return;

	my $userDraft = $self->req->json;

	# TODO:
	# - Validate.
	# - Save request in DB.
	# - Send email.

	# Password strong enough?
	$DB::single = 1;
	my $analysis = password_strength $userDraft->{password};
	my $score = $analysis->{score};
	my @errors;
	push @errors, {
		message => "Password too weak (score: $score/3)",
		path => 'body/password'
	} if $score < 3;

	return $self->errorResponse($code, @errors) if @errors;

	delete $userDraft->{password};

	$self->render(openapi => $userDraft, status => HTTP_CREATED);
}

1;
