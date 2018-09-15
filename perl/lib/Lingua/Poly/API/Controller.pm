#! /bin/false
#
# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018 Guido Flohr <guido.flohr@cantanea.com>
#               All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package Lingua::Poly::API::Controller;

use strict;

use Locale::TextDomain qw(Lingua-Poly);

use HTTP::Status qw(:constants);
use Lingua::Poly::API::Logger qw(session);
use Lingua::Poly::Util::String qw(empty http_date);

sub new {
    my ($class, @path_info) = @_;

    my $self = {
        _path_info => \@path_info,
    };

    bless $self, $class;
}

sub realm { 'session' }

sub pathInfo {
    shift->{_path_info};
}

sub auto {
    my ($self) = @_;

    my $session = $self->_authenticate;
    my $authorized = $self->_authorize($session) || return;
    if (!$authorized) {
        if ($session) {
            Lingua::Poly::API->new->resultError(HTTP_FORBIDDEN);
        } else  {
            Lingua::Poly::API->new->resultError(HTTP_UNAUTHORIZED);
        }
    }

    return $session;
}

sub _authenticate {
	my ($self) = @_;

	$self->debug("Trying to authenticate user.");
	my $api = Lingua::Poly::API->new;
	my $session_timeout = $api->config->{session}->{timeout};
	my $request = $api->request;

    my $session;
    my $cookies = $request->cookies;
    if ($cookies && exists $cookies->{tsid}) {
        my $session_id = $cookies->{tsid};
        $self->debug("Found session id.");
        $session = $api->session($session_id);
    }

    return $session if $session;

    return;
}

sub _authorize {
    my ($self, $session) = @_;

    my $uid = $session->{uid};

    # All methods are allowed for all logged in users by default.
    if (defined $uid) {
        $session->authorized(1);
        return $self;
    }

    return;
}

sub run { shift }

1;

