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

package Lingua::Poly::API::Logger;

use strict;

use Lingua::Poly::Util::String qw(empty);

use Time::HiRes qw(gettimeofday);

my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
my %realms;

sub import {
    my ($class, @args) = @_;
    
    return $class->SUPER::import(@args) if $class ne __PACKAGE__;

    my $realm = shift @args;
    
    my $caller = caller 0;

    if (!exists $realms{$caller}) {
        $realms{$caller} = $realm;
        no strict 'refs';
        push @{"$caller\::ISA"}, __PACKAGE__;
    }
    
    return;
}

sub __log {
    my ($self, $domain, $realm, @messages) = @_;

    $realm ||= $self->realm;

    my ($seconds, $useconds) = gettimeofday;

    my $pid = sprintf '0x%04x', $$;
    my ($sec, $min, $hour, $mday, $mon, $year) = localtime $seconds;
    my $timestamp = sprintf '%02u/%s/%04u %02u:%02u:%02u.%06u',
                            $mday, $months[$mon], $year + 1900,
                            $hour, $min, $sec, $useconds;

    my $prefix = "$timestamp [$domain][$realm][$pid]";
    foreach my $msg (@messages) {
        $msg =~ s/[ \t]*\n?$//o;
        foreach my $line (split /\n/, $msg) {
            $line =~ s/[ \t]*\n?$//o;
            warn "$prefix $line\n";
        }
    }

    return $self;
}

sub realm {
    my ($self) = @_;
    
    my $realm = $realms{ref $self};
    $realm = 'unspecified' if empty $realm;
    
    return $realm;
}

sub debug {
    my ($self, @messages) = @_;

    my $realm = $self->realm;

    return if !Lingua::Poly::API->new->debugging($realm);

    return $self->__log(debug => $realm, @messages);
}

sub info {
    my ($self, @messages) = @_;

    my $realm = $self->realm;

    return $self->__log(info => $realm, @messages);
}

sub warning {
    my ($self, @messages) = @_;

    my $realm = $self->realm;

    return $self->__log(warning => $realm, @messages);
}

sub error {
    my ($self, @messages) = @_;

    my $realm = $self->realm;

    return $self->__log(error => $realm, @messages);
}

sub fatal {
    my ($self, @messages) = @_;

    my $realm = $self->realm;

    $self->__log(fatal => $realm, @messages);

    exit 1;
}

1;
