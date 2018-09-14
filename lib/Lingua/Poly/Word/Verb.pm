# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018 Guido Flohr <guido.flohr@cantanea.com>
#               All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package Lingua::Poly::Word::Verb;

use strict;

use Carp;
use Locale::TextDomain qw(Lingua-Poly);

use base qw(Lingua::Poly::Word);

sub name { __"Verb" }

sub _preInflect {
    my ($self, $person, $numerus, %options) = @_;

    croak "Person must be 1, 2, or 3" if $person < 1 || $person > 3;
    croak "Numerus must be 1 or 2" if $numerus != 1 && $numerus != 2;
}

1;

=head1 NAME

Lingua::Poly::Word

=head1 SYNOPSIS

=head1 COPYRIGHT

Copyright (C) 2018 Guido Flohr  <guido.flohr@cantanea.com>, all rights
reserved.

This library is free software. It comes without any warranty, to
the extent permitted by applicable law. You can redistribute it
and/or modify it under the terms of the Do What the Fuck You Want
to Public License, Version 2, as published by Sam Hocevar. See
http://www.wtfpl.net/ for more details.

=head1 SEE ALSO

perl(1)
