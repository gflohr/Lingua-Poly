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

package Lingua::Poly::API;

use strict;

sub realm {
    return shift->{__initialized} ? 'core' : 'init';
}

use Time::HiRes qw(gettimeofday);
use Config::General;
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

my $api;

sub new {
    my ($class) = @_;
    
    return $api if $api;
    
    $api = bless {}, __PACKAGE__;
    
    $api->__initialize;
}

sub baseDirectory {
    shift->{__base_dir};
}

sub config {
    shift->{__config};
}

sub db {
    shift->{__db};
}

sub debugging {
    my ($self, $realm) = @_;

    $self->{__debug}->{all} || $self->{__debug}->{lc $realm};
}

sub finalizeRequest {
    my ($self) = @_;

    $self->db->finalize;

    return $self;
}

sub footprint {
    my ($self) = @_;
    
    my $request = $self->request;
    
    my $ua = $request->header('User-Agent');
    $ua //= '';
    
    my $ip = $request->address;
    
    return join ':', $ip, $ua;
}

sub initRequest {
    my ($self, $request) = @_;

    $self->{__request} = $request;
    
    my $response = $self->{__response} = $request->new_response(HTTP_OK);
    $response->content_type('application/json');

    $self->resultSuccess;
    
    delete $self->{__session};
    
    return $self;
}

sub request {
    shift->{__request};
}

sub response {
    shift->{__response};
}

sub run {
    my ($self) = @_;

    eval {
        my ($controller, @path_info) = $self->__controller;

        my $session = eval { $controller->auto(@path_info) };
        if ($@) {
            $self->resultError(HTTP_UNAUTHORIZED);
            $self->{__payload}->{description} = $@;
        } elsif (!$session) {
            $self->resultError(HTTP_UNAUTHORIZED);
        } else {
            $self->{__session} = $session;
            $controller->run(@path_info);
        }
    };
    if ($@) {
        $self->error($@);
        $self->resultError(HTTP_INTERNAL_SERVER_ERROR);
    }
    
    $self->__render;
    
    eval {
        $self->finalizeRequest;
    };
    if ($@) {
        $self->error($@);
    }
    
    return $self;
}

sub session {
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

sub resultSuccess {
    my ($self, $data) = @_;

    $self->{__payload} = {
        status => 'success',
        code => LINGUA_POLY_API_OK,
        result => $data,
    }; 
}

sub resultError {
    my ($self, $code) = @_;

    if ($code > 0) {
        $self->response->status($code);
    }

    $self->{__payload} = {
        status => 'error',
        code => $code,
        msg => Lingua::Poly::API::Error::message($code),
    };
}

sub requestContent {
    my ($self) = @_;
    
    return $self->{__request}->content;
}

sub __render {
    my ($self) = @_;

    require JSON;
    my $body = JSON->new->encode($self->{__payload});
    $body .= "\n";
    
    turn_utf_8_off $body;
    
    $self->response->body($body);

    return $self;
}

# Find and instantiate a controller path.
sub __controller {
    my ($self, $request) = @_;

    $request ||= $self->request;

    my $path = $request->uri->path;
    $self->debug("resolving controller path '$path'");
    my $prefix = $self->config->{prefix};
    if (!empty $prefix) {
        die "controller path '$path' outside of prefix '$prefix'.\n"
            if $path !~ s/^$prefix//;
        $self->debug("normalized controller path '$path'")
    }
    my @tries = split /\/+/, $path;
    $tries[0] = 'Controller';

    my $base_path = $self->baseDirectory . 'Lingua::Poly::API';
    my @path_info;
    while (@tries) {
        my $module_path = $base_path . '/' . join '/', @tries;
        $module_path .= '.pm';

        $self->debug("trying controller path '$module_path'"
                     . " with path_info /" . join '/', @path_info);

        if (-e $module_path) {
            my $class = join '::', 'Lingua::Poly::API', @tries;
            my $module_name = join '/', 'Lingua::Poly::API', @tries;
            $module_name .= '.pm';

            $self->debug("loading controller class '$class'");

            require $module_name;
            return ($class->new, @path_info);
        }
        push @path_info, pop @tries;
    }
   
    die "could not resolve controller path for URI " . $request->uri . "\n"; 
}


sub __initialize {
    my ($self) = @_;

    my $debug = $ENV{LINGUA_POLY_DEBUG} // '';
    my %debug = map { lc $_ => 1 } split /[ \t:,\|]/, $debug;
    $self->{__debug} = \%debug;

    $self->{__base_dir} = Cwd::abs_path(Cwd::getcwd);

    $self->{__config} = $self->__readConfig;

    my %system_conf = %{$self->{__config}};
    $system_conf{'DOCUMENT-ROOT'} = $system_conf{DOCUMENT_ROOT} 
        = $self->baseDirectory;

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
    my $config_file = "$base_dir/api.conf";
    $self->debug("Reading configuration file '$config_file'.");
    my %config = eval { Config::General->new($config_file)->getall };
    $self->fatal($@) if $@;

    $self->fatal("no <database> section in '$config_file'.") 
        unless $config{database};
    
    # Set default values.
    $config{session}->{timeout} //= 10 * 60;
        
    return \%config;
}

1;
