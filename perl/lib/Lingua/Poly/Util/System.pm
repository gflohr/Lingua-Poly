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

package Lingua::Poly::Util::System;

use strict;

use Password::OWASP::Argon2;

use base qw(Exporter);

use base 'Exporter';
use vars qw(@EXPORT_OK);

@EXPORT_OK = qw(crypt_password check_password);

sub crypt_password($) {
	return Password::OWASP::Argon2->new->crypt_password(shift);
}

sub check_password($$) {
	my ($cleartext, $digest) = @_;

	return Password::OWASP::Argon2->new->check_password($cleartext, $digest);
}

1;

