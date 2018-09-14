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

package Lingua::Poly::API::Core::PSGI;

use strict;

use CGI::Cookie;

use Lingua::Poly::API;
use Lingua::Poly::API::Logger qw(core);
use Lingua::Poly::Util::String qw(empty);

sub run {
    my ($self, $env) = @_;

    $env->{HTTP_HOST} = $env->{HTTP_X_FORWARDED_HOST} 
        if $env->{HTTP_X_FORWARDED_HOST};
    $env->{SERVER_PORT} = $env->{HTTP_X_FORWARDED_PORT} 
        if $env->{HTTP_X_FORWARDED_PORT};
    
    my $api = Lingua::Poly::API->new;
    $api->initRequest(Plack::Request->new($env));
  
    $api->run;

    return $api->response->finalize;
}

1;
