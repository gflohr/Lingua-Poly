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
use LPTestLib::MockService;

use Mojo::URL;

use Lingua::Poly::API::Users::Service::OAuth::Facebook;

my $prefix = '/api/prefix';

my $config = {
	prefix => $prefix,
};
my $database = LPTestLib::MockService->new;
my $email_service = LPTestLib::MockService->new;
my $logger = LPTestLib::MockService->new;
my $request_context_service = LPTestLib::MockService->new;
$request_context_service->mockMethod(origin => sub {
	return Mojo::URL->new('http://localhost:2304/');
});
my $rest_service = LPTestLib::MockService->new;
my $session_service = LPTestLib::MockService->new;
my $user_service = LPTestLib::MockService->new;

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

is $fb_service->redirectUri, $redirect_uri, 'Redirect URIR';

is $fb_service->authorizationUrl, undef, 'no client id';
$config->{oauth}->{facebook}->{client_id} = 'client_id';

is $fb_service->authorizationUrl, undef, 'no client secret';
$config->{oauth}->{facebook}->{client_secret} = 'client_secret';

done_testing;
