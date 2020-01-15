#! /bin/false

package BGTrainer::Word::Verb::II_179;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::II_178);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    return $self;
}

sub imperative {
    my ($self) = @_;

    my $stem = $self->{_stem};

    $stem =~ s/ърж$/ръж/;

    return ($self->_emphasize ($stem, -1),
	    $self->_emphasize ($stem . 'те', -1));
}

sub past_passive_participle {
    &BGTrainer::Word::Verb::past_passive_participle;
}

sub renarrative_passive {
    &BGTrainer::Word::Verb::renarrative_passive;
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
