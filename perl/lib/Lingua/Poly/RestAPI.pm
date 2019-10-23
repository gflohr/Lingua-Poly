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

package Lingua::Poly::RestAPI;

use strict;

use Mojo::Base 'Mojolicious';

sub realm {
    return shift->{__initialized} ? 'core' : 'init';
}

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

sub startup {
	my ($self) = @_;

	$self->plugin(OpenAPI => {
			spec => $self->static->file('openapi.yaml')->path,
			schema => 'v3',
	});
}

sub __session {
    my ($self, $session_id) = @_;

    if ($#_ > 0) {
        my $config = $self->config;

        my $path = $config->{prefix};
        $path = '/' if empty $path;

        $self->{__session} = Lingua::Poly::API::Session->new(
            session_id => $session_id);
        $session_id = $self->{__session}->id;
        $self->response->{cookies}->{tsid} = {
            path => $path,
            'max-age' => $config->{session}->{timeout},
            secure => $config->{session}->{ssl},
            httponly => 1,
            value => $session_id,
        };
    }

    return $self->{__session};
}

sub __initialize {
    my ($self) = @_;

    my $debug = $ENV{LINGUA_POLY_DEBUG} // '';
    my %debug = map { lc $_ => 1 } split /[ \t:,\|]/, $debug;
    $self->{__debug} = \%debug;

    $self->{__base_dir} = Cwd::abs_path(Cwd::getcwd);

    $self->{__config} = $self->__readConfig;

    $self->{__db} = Lingua::Poly::API::DB->new($self->{__config}->{database});

    # Throw away old sessions.
    $self->{__db}->transaction(DELETE_SESSION_STALE
                               => 24 * 6 * $self->config->{session}->{timeout});

    $self->{__initialized} = 1;

    return $self;
}

sub __readConfig {
    my ($self) = @_;

    my $base_dir = $self->baseDirectory;
    my $config_file = "$base_dir/api.conf.yaml";
    $self->debug("reading configuration file '$config_file'.");
    open my $fh, '<', $config_file
         or $self->fatal("cannot open '$config_file' for reading: $!");
    my $yaml = join '', $fh->getlines;
    my $config = eval { YAML::Load($yaml) };
    $self->fatal($@) if $@;

    $self->fatal("no database section in '$config_file'.")
        unless $config->{database};

    # Set default values.
    $config->{session}->{timeout} //= 10 * 60;

    return $config;
}

1;
