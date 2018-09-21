# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018 Guido Flohr <guido.flohr@cantanea.com>
#               All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package Lingua::Poly::FI::Word::Verb::Type2;

use strict;
use utf8;

use Locale::TextDomain qw(Lingua-Poly);

use base qw(Lingua::Poly::FI::Word::Verb);

sub inflect {
    my ($self, $person, $numerus, %options) = @_;
 
    my $stem;
    if ($$self =~ /[hH]..$/) {
        # nähdä or tehdä.
        $stem = substr $$self, 0, -3;
        $stem .= $person == 3 ? 'ke' : 'e';
    } else {
        $stem = substr $$self, 0, -2;
    }

    if ($person == 1 && $numerus == 2) {
        my $regular = $self->_ending($stem, $person, $numerus);
        my $coll =  $$self;
        $coll =~ s/(.)$/$1$1n/;
        return [$regular, $coll];
    }

    return $self->_ending($stem, $person, $numerus);
}

1;

=head1 NAME

Lingua::Poly::FI::Word::Verb::Type2;

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
