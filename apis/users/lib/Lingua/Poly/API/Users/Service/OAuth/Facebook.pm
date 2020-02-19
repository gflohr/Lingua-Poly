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

package Lingua::Poly::API::Users::Service::OAuth::Facebook;

use strict;

use Moose;
use namespace::autoclean;
use LWP::UserAgent;
use HTTP::Request;
use JSON;
use Mojo::URL;

use Lingua::Poly::API::Users::Util qw(empty equals decode_jwt);
use Lingua::Poly::API::Users::Service::OAuth::Google::Discovery;

use base qw(
	Lingua::Poly::API::Users::Logging
);

has logger => (is => 'ro', required => 1);
has configuration => (is => 'ro', required  => 1);
has database  => (
	is => 'ro',
	required => 1,
	isa => 'Lingua::Poly::API::Users::Service::Database'
);
has requestContextService => (
	is => 'ro',
	required => 1,
	isa => 'Lingua::Poly::API::Users::Service::RequestContext',
);
has sessionService => (
	is => 'ro',
	required => 1,
	isa => 'Lingua::Poly::API::Users::Service::Session',
);
has restService => (
	isa => 'Lingua::Poly::API::Users::Service::RESTClient',
	is => 'ro',
	required => 1,
);
has userService => (
	isa => 'Lingua::Poly::API::Users::Service::User',
	is => 'ro',
	required => 1,
);
has emailService => (
	isa => 'Lingua::Poly::API::Users::Service::Email',
	is => 'ro',
	required => 1,
);

# FIXME! Factor that out into a base class method.
sub redirectUri {
	my ($self, $ctx) = @_;

	my $redirect_url = $self->requestContextService->origin($ctx)->clone;

	my $config = $self->configuration;

	$redirect_url->path("$config->{prefix}/oauth/facebook");

	return $redirect_url;
}

sub authorizationUrl {
	my ($self, $ctx) = @_;

	my $config = $self->configuration;
	my $client_id = $config->{oauth}->{facebook}->{client_id};
	return if empty $client_id;

	my $client_secret = $config->{oauth}->{facebook}->{client_secret};
	return if empty $client_secret;

	my $redirect_uri = $self->redirectUri($ctx);

	my $session = $ctx->stash->{session};

	my $authorization_url = URI->new('https://www.facebook.com/v6.0/dialog/oauth');
	$authorization_url->query_form(
		client_id => $client_id,
		redirect_uri => $redirect_uri,
		state => $self->sessionService->getState($session),
		response_type => 'code',
		scope => 'email',
	);

	return $authorization_url;
}

sub authenticate {
	my ($self, $ctx, %params) = @_;

	my $config = $self->configuration;

	my $client_id = $config->{oauth}->{facebook}->{client_id}
		or die "no facebook client id\n";
	my $client_secret = $config->{oauth}->{facebook}->{client_secret}
		or die "no facebook client secret\n";

	my $session = $ctx->stash->{session};
	my $state = $self->sessionService->getState($session);
	die "state mismatch\n" if $params{state} ne $state;

	my $redirect_uri = $self->redirectUri($ctx);

	my $form = {
		code => $params{code},
		client_id => $client_id,
		client_secret => $client_secret,
		redirect_uri => $redirect_uri->to_string,
	};

	my $token_endpoint = URI->new(
		'https://graph.facebook.com/v6.0/oauth/access_token'
	);
	$token_endpoint->query_form($form);

	my ($payload, $response) = $self->restService->get($token_endpoint);
	my $now = time;
	die $response->status_line if !$response->is_success;

	die "facebook did not send an access token"
		if empty $payload->{access_token};
	my $access_token = $payload->{access_token};

	my $profile_url = URI->new('https://graph.facebook.com/v6.0/me/');
	$profile_url->query_form(
		access_token => $access_token,
		fields => 'id,email',
		method => 'get',
	);

	($payload, $response) = $self->restService->get($profile_url);
	die $response->status_line if !$response->is_success;

	die "facebook did not send a user id" if empty $payload->{id};

	my $location = Mojo::URL->new($self->configuration->{origin});
	my ($id, $email) = @{$payload}{qw(id email)};

	# Everything from here on is generic and should go into a common method.
	$email = $self->emailService->parseAddress($email) if !empty $email;

	my $user = $self->userService->userByExternalId(
		FACEBOOK => $id
	);
	my $user_by_email = $self->userService->userByUsernameOrEmail($email)
		if !empty $email;
	my $external_id = "FACEBOOK:$id";

	if ($user) {
		if ($user_by_email && $user_by_email->id ne $user->id) {
			# We have to delete the conflicting user in the database and
			# merge the data.
			$user->merge($user_by_email);
			$self->userService->deleteUser($user_by_email);
			$self->userService->updateUser($user);
		}
	} elsif ($user_by_email) {
		# User had logged in before but in another way.
		$user = $user_by_email;
		if (!equals $user->externalId, $user_by_email->externalId) {
			$user->externalId($external_id);
		}
	} else {
		# New user.
		$user = $self->userService->create($email,
			externalId => $external_id,
			confirmed => 1,
		);
	}

	# Not else! Variable $user may have been assiged to!
	if ($user) {
		my $session = $ctx->stash->{session};
		$session->user($user);
		$session->nonce(undef);
		$session->provider('GOOGLE');
		$session->token($payload->{access_token});
		$session->token_expires($now + $payload->{expires_in});
		$self->sessionService->renew($session);
	}

	$self->database->commit;

	return $location;
}

sub revoke {
	my ($self, $token, $token_expires) = @_;

	return $self if $token_expires < time;

	die;
}

__PACKAGE__->meta->make_immutable;

1;


=head1 NAME

Lingua::Poly::API::Users::Service::OAuth::Facebook; - Facebook OAuth Service

=head1 SYNOPSIS

    $fb_oauth = Lingua::Poly::API::Users::Service::OAuth::Facebook->new(
        logger => $logger,
        configuration => $configuration,
        database => $database,
        requestContextService => $request_context_service,
        sessionService => $session_service,
        resetService => $rest_service,
        userService => $user_service,
        emailService => $email_service,
    );

=head1 DESCRIPTION

This service is responsible for the authentication via
L<Facebook|https://www.facebook.com/>.

=head1 CONSTRUCTOR

The following services are injected into the constructor:

=over 4

=item B<logger>

A L<Lingua::Poly::API::Users::SmartLogger> service.
This property is required.  It is read-only.

=item B<configuration>

A configuration hash reference, for example a
L<Lingua::Poly::API::Users::Config> object.

=item B<requestContextService>

A L<Lingua::Poly::API::Users::Service::RequestContextService>.
This property is required. It is read-only.

=item B<sessionService>

A L<Lingua::Poly::API::Users::Service::SessionService>.
This property is required. It is read-only.

=item B<restService>

A L<Lingua::Poly::API::Users::Service::RestService>.
This property is required. It is read-only.

=item B<userService>

A L<Lingua::Poly::API::Users::Service::UserService>.
This property is required. It is read-only.

=item B<emailService>

A L<Lingua::Poly::API::Users::Service::EmailService>.
This property is required. It is read-only.

=back

=head1 METHODS

=over 4

=item B<authorizationUrl CONTROLLER>

Returns a L<Mojo::URL> for the OAuth2 authorization URL.  This URL will display
the Facebook login dialog for the user.  You have to pass the
L<Mojo::Controller> initiating the login, so that the server origin and the
user session can be retrieved.

=item B<redirectUri CONTROLLER>

Returns a L<Mojo::URL> for the OAuth2 redirect URL.  You have to pass the
L<Mojo::Controller> initiating the login, so that the server origin can be
retrieved.

=item B<authenticate CONTROLLER, PARAMS>

Returns a L<Mojo::URL> that the user should be redirected to after having
successfully logged in.  This is the application start page, with optional
query parameters.  You have to pass q
L<Mojo::Controller> (normally the controller that responded to the redirect
URL) and all query parameters that the redirect URL was requested with.

An exception is thrown in case of failure.

=item B<revoke TOKEN, TOKEN_EXPIRES>

Revokes the access token B<TOKEN> issued by Facebook.  If the unix timestamp
B<TOKEN_EXPIRES> is in the future, nothing happens.

=back

=head1 SEE ALSO

L<https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow>,
L<Lingua::Poly::API::Users::SmartLogger>,
L<Lingua::Poly::API::Users::Config>,
L<Lingua::Poly::API::Users::Service::RequestContextService>,
L<Lingua::Poly::API::Users::Service::SessionService>,
L<Lingua::Poly::API::Users::Service::RESTService>,
L<Lingua::Poly::API::Users::Service::UserService>,
L<Lingua::Poly::API::Users::Service::EmailService>,
L<Mojo::URL>, L<perl>
