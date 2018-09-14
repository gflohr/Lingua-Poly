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

package Lingua::Poly::Util::String;

use strict;

use base qw(Exporter);

our @EXPORT_OK = qw(empty http_date trim force_integer);

sub http_date($) {
    my ($seconds) = @_;
    
    $seconds ||= 0;
    
    my ($sec, $min, $hour, $mday, $mon, $year, $wday) = gmtime $seconds;
    my @wdays = qw(Sun Mon Tue Wed Thu Fri Sat);
    my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
    
    return sprintf '%s, %02u-%s-%02u %02u:%02u:%02u GMT',
                   $wdays[$wday], $mday, $months[$mon], $year + 1900,
                   $hour, $min, $sec;
}

sub empty($) {
    return if defined $_[0] && length $_[0];

    return 1;
}

sub trim($) {
    my ($string) = @_;
    
    $string = '' if !defined $string;
    $string =~ s/^[ \t]+//;
    $string =~ s/[ \t]+$//;
    
    return $string;
}

sub force_integer($$;$$) {
	my ($value, $default, $min, $max) = @_;
	
    $value = $default if !defined $value;	

    $value =~ s/[^0-9]//g;
    $value =~ s/^0+//;
    $value ||= 0;
    
    $value *= 1;
    
    $value = $min if defined $min && $value < $min;
    $value = $max if defined $max && $value > $max;
    
    return $value;
}

1;
