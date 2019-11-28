#! /bin/false
#
# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018-2019 Guido Flohr <guido.flohr@Lingua::Poly::API.com>
#			   All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package Lingua::Poly::API::UM::Service::User;

use strict;

use base qw(Lingua::Poly::API::UM::Logging);

use Moose;

has 'logger' => (is => 'ro');
has 'database' => (is => 'ro');

__PACKAGE__->meta->make_immutable;

1;
