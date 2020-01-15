#! /bin/false

package BGTrainer::Word::Verb::I_169;

use strict;

use utf8;

# FIXME: Inheritance should be the other way round.
use base qw (BGTrainer::Word::Verb::I_168);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    $self->{_gerund_stem} = $self->{_stem} . 'е';

    return $self;
}

sub imperative {
    my ($self) = @_;

    my $stem = $self->{_stem};
    chop $stem;
    $stem .= 'ж';

    return ($self->_emphasize ($stem, -1),
	    $self->_emphasize ($stem . 'те', -2));
}

sub present_active_participle {
    &BGTrainer::Word::Verb::present_active_participle;
}

sub verbal_noun {
    &BGTrainer::Word::Verb::verbal_noun;
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
