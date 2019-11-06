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

use Lingua::Poly::API::Logger;
use Lingua::Poly::API::DB;
use Lingua::Poly::Util::String qw(empty);
use Lingua::Poly::API::Session;
use Lingua::Poly::API::Error;

use Mojo::Base "Lingua::Poly::RestAPI::Controller";

sub realm { "user" }

sub create {
	my $self = shift->openapi->valid_input or return;

	$DB::single = 1;
	my $userDraft = $self->req->json;

	use Data::Dumper;
	#$self->debug(Dumper $userDraft);
	warn Dumper $userDraft;

	delete $userDraft->{password};

	$self->render(openapi => $userDraft, status => 201);
}

1;
