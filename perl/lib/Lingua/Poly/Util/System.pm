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

package Lingua::Poly::Util::System;

use strict;

use base qw(Exporter);

use vars qw(@EXPORT_OK);

@EXPORT_OK = qw(random_bytes random_chars password_digest);

sub random_bytes($) {
    my ($number) = @_;
    
    open my $fh, "</dev/urandom" 
        or die "Cannot open '</dev/urandom' for reading: $!\n";
    $number == sysread $fh, my $bytes, $number
        or die "Cannot read from '</dev/urandom': $!\n";
        
    return $bytes;
}

sub random_chars($) {
    my ($number) = @_;
    
    my $length = 1 + int (3 * $number / 4);
    my $bytes = random_bytes $length;
    
    require MIME::Base64;
    
    my $string = MIME::Base64::encode_base64url($bytes);

    return substr $string, 0, $number;
}

sub password_digest($) {
    my ($cleartext) = @_;
    
    require Digest::SHA;
    
    return '{SHA512}' . (Digest::SHA::sha512_hex $cleartext) . '=';
}

1;
