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
use Email::Simple 2.216;
use Email::Sender::Simple 1.300031 qw(sendmail);

use Lingua::Poly::Util::String qw(empty);
use Lingua::Poly::Util::System qw(crypt_password check_password);
use Lingua::Poly::RestAPI::Logger;
use Lingua::Poly::RestAPI::User;

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

	my $body;
	my $subject;
	my $expiry_minutes = $self->config->{session}->{timeout} / 60;
	if ($suggest_recover) {
		die "recover not yet implemented";
	} else {
		my $token;
		if ($renew_request) {
			($token) = $db->getRow(SELECT_TOKEN_BY_PURPOSE => 'registration',
			                       $userDraft->{email});
			die "no registration token for $userDraft->{email} found"
			    if empty $token;
			$db->execute(UPDATE_TOKEN => 'registration', $userDraft->{email});
		} else {
			# Create the  user.
			my $password = crypt_password $userDraft->{password};

			$db->execute(INSERT_USER => $userDraft->{email},
			             crypt_password $userDraft->{password});
			my $user_id = $db->lastInsertId('users');
			$token = $self->random_string(entropy => 128);
			$db->execute(INSERT_TOKEN => $token, 'registration', $user_id);
		}

		my $transport = $self->emailSenderTransport;
		my $url = $self->siteURL;
		my $confirmation_url = Mojo::URL->new($url);
		$confirmation_url->path("/registration/confirmed/$token");

		$subject = 'Confirm Lingua::Poly registration';
		$body = <<EOF;
Hello,

somebody, hopefully you, has registered at the Lingua::Poly website
($url).

If you did not register, please ignore this email!

In order to confirm the registration, please follow the following
link:

     $confirmation_url

There is no need to keep this email.  The above link will expire in
$expiry_minutes minutes.

This email was send from an account that is not set up to receive mails.

Best regards,
Your Lingua::Poly team
EOF
	}

	my $email = Email::Simple->create(
		header => [
			To => $userDraft->{email},
			From => $self->config->{smtp}->{sender},
			Subject => $subject,
		],
		body => $body,
	);

	sendmail $email, { transport => $self->emailSenderTransport };

	$db->commit;

	my %user = (email => $userDraft->{email});
	$self->render(openapi => \%user, status => HTTP_CREATED);
}

sub confirmRegistration {
	my $self = shift->openapi->valid_input or return;

	my $in = $self->req->json;
	if (!exists $in->{token}) {
		return $self->errorResponse(HTTP_BAD_REQUEST, {
			message => 'no token provided'
		});
	}
	my $token = $in->{token};

	my $db = $self->stash->{db};
	my ($user_id, $username, $email) = $db->getRow(
		SELECT_TOKEN => 'registration',
		$token
	);

	if (!defined $user_id) {
		$db->rollback;
		return $self->errorResponse(HTTP_GONE, {
			message => 'token not found'
		});
	}

	my %user = (email => $email, username => $username);
	foreach my $prop (keys %user) {
		delete $user{$prop} if !defined $user{$prop};
	}

	# FIXME! Upgrade session cookie!
	$db->transaction(
		[UPDATE_USER_ACTIVATE => $user_id],
		[DELETE_TOKEN => $token]
	);

	$self->render(openapi => \%user, status => HTTP_OK);
}

sub login {
	my $self = shift->openapi->valid_input or return;

	my $login_data = $self->req->json;
	my $db = $self->stash->{db};

	my $user = Lingua::Poly::RestAPI::User->new($db, $login_data->{id});
	return $self->errorResponse(HTTP_UNAUTHORIZED, {
		message => 'invalid username or password'
	}) if !$user;
	return $self->errorResponse(HTTP_UNAUTHORIZED, {
		message => 'invalid username or password'
	}) if !check_password $login_data->{password}, $user->password;

	my %user = (
		sessionTTL => $self->config->{session}->{timeout},
	);
	$user{email} = $user->email if defined $user->email;
	$user{username} = $user->username if defined $user->username;

	$self->render(openapi => \%user, status => HTTP_OK);
}

sub profile {
	my $self = shift->openapi->valid_input or return;

	my %user = (
		email => 'karl.dapp@der.abwaschba.re',
		username => 'Karl Dapp',
		sessionTTL => $self->config->{session}->{timeout},
	);

	return $self->render(openapi => \%user, status => HTTP_OK);

	return $self->errorResponse(HTTP_UNAUTHORIZED, {
		message => 'You are not logged in.'
	});
}

1;
