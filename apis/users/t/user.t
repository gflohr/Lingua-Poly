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

my $user_by_email = Lingua::Poly::API::Users::Model::User->new(
	id => 1,
	email => 'foo@bar.baz',
	username => 'Foo Bar',
	homepage => 'http://old.bar.baz/',
);
ok $user_by_email;
my $user_by_external_id = Lingua::Poly::API::Users::Model::User->new(
	id => 2,
	externalId => 'GOOGLE:abcdef',
	email => 'foo@bar.baz',
	homepage => 'http://www.bar.baz/',
	description => 'That is me.',
);
ok $user_by_external_id;

$user_by_external_id->merge($user_by_email);

is $user_by_external_id->id, 2, 'user id';
is $user_by_external_id->email, 'foo@bar.baz';
is $user_by_external_id->username, 'Foo Bar';
is $user_by_external_id->externalId, 'GOOGLE:abcdef';
is $user_by_external_id->description, 'That is me.';

done_testing;
