#! /bin/false

package BGTrainer::Word::Verb::III_187;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::III_186);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    my $stem = $word;
    $stem =~ s/.$//;

    $self->{_stem} = $stem;

    return $self;
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
