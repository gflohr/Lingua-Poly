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

package Lingua::Poly::API::Users::Model::Session;

use strict;

use Moose;
use namespace::autoclean;

has sid => (isa => 'Str', is => 'rw');
has user => (isa => 'Lingua::Poly::API::Users::Model::User', is => 'rw');
has provider => (is => 'rw');

__PACKAGE__->meta->make_immutable;

1;

