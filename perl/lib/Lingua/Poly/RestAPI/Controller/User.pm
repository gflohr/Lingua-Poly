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
use Data::Password::zxcvbn 1.0.4 qw(password_strength);
use Email::Address 1.912;

use Lingua::Poly::RestAPI::Logger;
use Lingua::Poly::RestAPI::User;
use Lingua::Poly::RestAPI::Util qw(crypt_password);

use Mojo::Base "Lingua::Poly::RestAPI::Controller";

sub realm { "user" }

sub create {
	my $self = shift->openapi->valid_input or return;

	my $userDraft = $self->req->json;
	my $db = $self->stash->{db};

	my @errors;

	# Valid email address?
	my @addresses = Email::Address->parse($userDraft->{email});
	if (!@addresses) {
		delete $userDraft->{email};
		push @errors, {
			message => 'Invalid email address specified.',
			path => '/body/email',
		};
	} elsif (@addresses != 1) {
		delete $userDraft->{email};
		push @errors, {
			message => 'More than one email address specified.',
			path => '/body/email',
		};
	} else {
		$userDraft->{email} = $addresses[0]->address;
	}

	my $suggest_recover;
	my $renew_request;
	if (exists $userDraft->{email}) {
		# Email already taken?
		my $existing = Lingua::Poly::RestAPI::User->new(
			$db, $userDraft->{email}, 1);
		if ($existing) {
			if ($existing->confirmed) {
				# We must never report to the user the email address is already in
				# our  system, as this would leak personal data.  Instead, we send
				# a mail but suggest to recover the password instead.
				$suggest_recover = 1;
			} else {
				# Probably something went wrong with the confirmation.  Simply
				# renew the request.
				$renew_request = 1;
			}
		}
	}

	# Password strong enough?
	my $analysis = password_strength $userDraft->{password};
	my $score = $analysis->{score};
	push @errors, {
		message => "Password too weak (score: $score/3).",
		path => '/body/password'
	} if $score < 3;

	if (@errors) {
		$db->rollback;
		return $self->errorResponse(HTTP_BAD_REQUEST, @errors);
	}

	if ($renew_request) {
		# We send a new mail and renew the "session".
		die "not yet implemented";
	} elsif ($suggest_recover) {
		die "not yet implemented";
	} else {
		# Create the  user.
		my $password = crypt_password $userDraft->{password};
		my $fingerprint = $self->fingerprint;
	}
	delete $userDraft->{password};

	$self->render(openapi => $userDraft, status => HTTP_CREATED);
}

1;
