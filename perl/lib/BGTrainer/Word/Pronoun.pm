#! /bin/false

package BGTrainer::Word::Pronoun;

use strict;

use utf8;

use base qw (BGTrainer::Word);
use Locale::TextDomain qw (net.guido-flohr.bgtrainer);

sub base_inflections {
    my ($self, $type) = @_;

    return qw (none);
}

sub describeVariations {
    return [];
}

1;

#Local Variables:
#mode: perl
#perl-indent-level: 4
#perl-continued-statement-offset: 4
#perl-continued-brace-offset: 0
#perl-brace-offset: -4
#perl-brace-imaginary-offset: 0
#perl-label-offset: -4
#cperl-indent-level: 4
#cperl-continued-statement-offset: 2
#tab-width: 8
#coding: utf-8
#End:
