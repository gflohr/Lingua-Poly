#! /usr/bin/env perl

# Copyright (C) 2018 Guido Flohr <guido.flohr@cantanea.com>,
# all rights reserved.

# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

use strict;

use lib 't';

use Test::More;

use Mojo::URL;
use Session::Token;
use URI;

use LPTestLib::MockService;

use Lingua::Poly::API::Users::Service::OAuth::Facebook;
use Lingua::Poly::API::Users::Service::Session;
use Lingua::Poly::API::Users::Config;

my $prefix = '/api/prefix';

my $config = LPTestLib::MockService->new;
$config->{prefix} = $prefix;
$config->{secrets} = [Session::Token->new(entropy => 256)->get];
$config->mockMethod(secret => \&Lingua::Poly::API::Users::Config::secret);

my $database = LPTestLib::MockService->new;
my $email_service = LPTestLib::MockService->new;
my $logger = LPTestLib::MockService->new;
my $request_context_service = LPTestLib::MockService->new;
$request_context_service->mockMethod(origin => sub {
	return Mojo::URL->new('http://localhost:2304/');
});
my $rest_service = LPTestLib::MockService->new;
my $user_service = LPTestLib::MockService->new;
my $session_service = Lingua::Poly::API::Users::Service::Session->new(
	logger => $logger,
	configuration => $config,
	database => $database,
	userService => $user_service,
);

my $fb_service = Lingua::Poly::API::Users::Service::OAuth::Facebook->new(
	logger => $logger,
	configuration => $config,
	database => $database,
	emailService => $email_service,
	requestContextService => $request_context_service,
	restService => $rest_service,
	sessionService => $session_service,
	userService => $user_service,
);

ok $fb_service;

my $redirect_uri = Mojo::URL->new('http://localhost:2304');
$redirect_uri->path("$prefix/oauth/facebook");

is $fb_service->redirectUri, $redirect_uri, 'Redirect URI';

my $session = Lingua::Poly::API::Users::Model::Session->new(
	sid => Session::Token->new(entropy => 256)->get,
);
my $ctx = LPTestLib::MockService->new;
my $stash = {
	session => $session,
};
$ctx->mockMethod(stash => sub { $stash });

is $fb_service->authorizationUrl($ctx), undef, 'no client id';
$config->{oauth}->{facebook}->{client_id} = 'client_id';

is $fb_service->authorizationUrl($ctx), undef, 'no client secret';
$config->{oauth}->{facebook}->{client_secret} = 'client_secret';

my $state = $session_service->getState($session);

my $auth_url = URI->new('https://www.facebook.com/v6.0/dialog/oauth');
$auth_url->query_form(
	client_id => 'client_id',
	redirect_uri => $redirect_uri,
	state => $state,
	response_type => 'code',
	scope => 'email'
);
is $fb_service->authorizationUrl($ctx), $auth_url, 'authorization URL';

my @alphabet = ('-', '_', 'A' .. 'Z', 'a' .. 'z', '0' .. '9');
my $code = Session::Token->new(alphabet => \@alphabet, length => 340)->get;

my %params = (
	state => $state,
	code => $code,
);

my %token = (
	expires_in => '5165402',
	token_type => 'bearer',
	access_token => Session::Token->new(length => 185)->get,
);


done_testing;
