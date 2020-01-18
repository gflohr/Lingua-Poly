#! /usr/bin/env perl

# Copyright (C) 2018 Guido Flohr <guido.flohr@cantanea.com>,
# all rights reserved.

# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

use strict;

use Test::More;

use Lingua::Poly::API::Users::Model::User;
use Lingua::Poly::API::Users::Model::Session;
use Lingua::Poly::API::Users::Service::Session;
use Lingua::Poly::API::Users::Config;

my $user = Lingua::Poly::API::Users::Model::User->new(id => 1);
ok $user;

my $session = Lingua::Poly::API::Users::Model::Session->new(
	sid => 'session id',
	user => $user,
);
ok $session;

my $config = bless {
	secrets => ['MZvl5lxqpxYanaMidLFdWui2TsegLmaA1O8lNMHRgCz']
}, 'Lingua::Poly::API::Users::Config';

my $sessionService = Lingua::Poly::API::Users::Service::Session->new(
	configuration => $config,
);
ok $sessionService;



done_testing;
