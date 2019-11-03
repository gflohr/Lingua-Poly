#! /bin/false
#
# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018-2019 Guido Flohr <guido.flohr@Lingua::Poly::API.com>
#               All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package Lingua::Poly::API::Error;

use strict;

use HTTP::Status;

use base qw(Exporter);

our @EXPORT;

my @errors = (
    [LINGUA_POLY_API_OK => 'Okay.'],
    # More constants ...
);

my $code = 0;
my @messages;

foreach my $error (@errors) {
    eval "use constant $error->[0] => $code";
    push @EXPORT, $error->[0];
    $messages[-$code] = $error->[1];
    --$code;
}

sub message {
    my ($code) = @_;

    if ($code > 0) {
        my $message = HTTP::Status::status_message($code);
        return $message if defined $message;
        return $code;
    }

    $code = -$code;
    if ($code >= 0 && $code <= $#messages) {
        return $messages[$code];
    } else {
        return "unknown error";
    }
}

1;
