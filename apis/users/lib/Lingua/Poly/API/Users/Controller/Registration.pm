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

package Lingua::Poly::API::Users::Controller::Registration;

use strict;

use HTTP::Status qw(:constants);
use Data::Password::zxcvbn 1.0.4 qw(password_strength);
use Email::Simple 2.216;
use Email::Sender::Simple 1.300031 qw(sendmail);

use Lingua::Poly::API::Users::Util qw(empty crypt_password check_password);

use Mojo::Base qw(Lingua::Poly::API::Users::Controller);

sub createUser {
	my $self = shift->openapi->valid_input or return;

	my $userDraft = $self->req->json;

	my @errors;

	# Valid email address?
	my $email = $self->app->emailService->parseAddress($userDraft->{email});
	if (!$email) {
		delete $userDraft->{email};
		push @errors, {
			message => 'Invalid email address specified.',
			path => '/body/email',
		};
	} else {
		$userDraft->{email} = $email;
	}

	my $suggest_recover;
	my $renew_request;
	if (exists $userDraft->{email}) {
		# Email already taken?
		my $existing = $self->app->userService->userByUsernameOrEmail(
			$userDraft->{email});
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
		$self->app->database->rollback;
		return $self->errorResponse(HTTP_BAD_REQUEST, @errors);
	}

	my $body;
	my $subject;
	my $expiry_minutes = $self->config->{session}->{timeout} / 60;
	if ($suggest_recover) {
		die "recover not yet implemented";
	} else {
		my $token;
		my $tokenService = $self->app->tokenService;
		if ($renew_request) {
			($token) = $tokenService->byPurpose(
				registration => $userDraft->{email});
			if (empty $token) {
				die "no registration token for $userDraft->{email} found";
				$self->app->database->rollback;
			}
			$tokenService->update(registration => $userDraft->{email});
		} else {
			# Create the  user.
			$self->app->userService->create(
				$userDraft->{email},
				password => $userDraft->{password},
			);
			$token = $tokenService->create(registration => $userDraft->{email});
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

	$self->app->database->commit;

	my $email = Email::Simple->create(
		header => [
			To => $userDraft->{email},
			From => $self->config->{smtp}->{sender},
			Subject => $subject,
		],
		body => $body,
	);

	sendmail $email, { transport => $self->emailSenderTransport };

	my %user = (email => $userDraft->{email});

	$self->render(json => \%user, status => HTTP_CREATED);
}

sub confirm {
	my $self = shift->openapi->valid_input or return;

	my $in = $self->req->json;
	if (!exists $in->{token}) {
		return $self->errorResponse(HTTP_BAD_REQUEST, {
			message => 'no token provided'
		});
	}
	my $token = $in->{token};

	my $user = $self->app->userService->byToken(registration => $token);
	if (!$user) {
		$self->app->database->rollback;
		return $self->errorResponse(HTTP_GONE, {
			message => 'token not found'
		});
	}

	my %user = (email => $user->email, username => $user->username);
	foreach my $prop (keys %user) {
		delete $user{$prop} if !defined $user{$prop};
	}

	my $session = $self->stash->{session};
	$session->user($user);
	$session->nonce(undef);

	$self->app->userService->activate($user);
	$self->app->tokenService->delete($token);
	$self->app->sessionService->renew($session);
	$self->app->database->commit;

	$self->render(openapi => \%user, status => HTTP_OK);
}

1;
