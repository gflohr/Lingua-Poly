#! /bin/false
#
# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018 Guido Flohr <guido.flohr@Lingua::Poly::API.com>
#               All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package Lingua::Poly::API::Session;

use strict;

use Lingua::Poly::API::Logger qw(session);
use Lingua::Poly::Util::String qw(empty http_date);
use Lingua::Poly::Util::System qw(random_chars);

sub new {
	my ($class, %args) = @_;

    my $self = bless {}, $class;

    my $api = Lingua::Poly::API->new;
    my $db = $api->db;

    my ($session_id, $uid);
        
    my $footprint = $api->footprint;
    my $config = $api->config;
    if (exists $args{uid}) {
        # We have to create a fresh session.
        $uid = $args{uid};
        $session_id = random_chars 128;
        $self->debug("Created new session '$session_id'.");
        $db->execute(DELETE_SESSION => $session_id);
        $db->transaction(INSERT_SESSION => $session_id, $uid,
                                           $footprint);
    } elsif (exists $args{session_id}) {
        # Check existing session.
        $session_id = $args{session_id};
        my ($old_footprint, $age);
        ($uid, $age, $old_footprint) = $db->getRow(SELECT_SESSION_INFO => $session_id);
        die "Session has expired.\n" if !defined $uid;
        die "Session has expired.\n" if $age > $config->{session}->{timeout};
        die "You were still logged in from somewhere else.\n"
            if $footprint ne $old_footprint;
            
        $db->transaction(UPDATE_SESSION => $session_id);
    } else {
        require Carp;
        Carp::croak("Sessions have to be created with either a uid or session_id");
    }
    
    $Lingua::Poly::API->response->cookies->{tsid} = {
    	value => $session_id,
    	'max-age' => $config->{session}->{timeout},
    	path => $config->{prefix},
    	secure => $config->{session}->{secure},
    	httponly => 1,
    };
    
    $self->{__id} = $session_id;
    $self->{__uid} = $uid;
    
    return $self;
}

sub id {
	shift->{__id};
}

sub uid {
	shift->{__uid};
}

sub authorized {
    my ($self, $authorized) = @_;

    $self->{__authorized} = 1 if (@_ >  1);

    return $self if $self->{__authorized};
    return;
}

1;
