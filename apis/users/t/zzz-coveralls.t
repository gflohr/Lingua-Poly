#! /usr/bin/env perl

# Copyright (C) 2018 Guido Flohr <guido.flohr@cantanea.com>,
# all rights reserved.

# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

use strict;

use Test::More tests => 1;
use File::Find;

# The only purpose of this test is to enforce inclusion of *all* files in
# the coverage output.

my $lib_dir = __FILE__;
$lib_dir =~ s{t/[^/]+\.t$}{lib} or die;

my $wanted = sub {
	my $module =  $File::Find::name;
	return if -d $module;
	return if $module !~ /\.pm$/;

	$module =~ s{^lib/}{};

	open OLDERR, '>&', STDERR or die $!;
	close STDERR;
	eval { require $module };
	open STDERR, '>&', OLDERR;
};

find { wanted => $wanted, no_chdir => 1, follow => 1}, $lib_dir;

ok 1;

