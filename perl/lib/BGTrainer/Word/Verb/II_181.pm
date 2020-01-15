#! /bin/false

package BGTrainer::Word::Verb::II_181;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::II_174);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    $self->{_aorist_stem1} = $word;
    $self->{_aorist_stem2} = $word;

    $self->{_imperfect_stem2} = $word;
    $self->{_imperfect_stem2} =~ s/я$/е/;

    $self->{_perfect_stem1} = $word;
    $self->{_perfect_stem3} = $word;
    $self->{_perfect_stem3} =~ s/я$/е/;
    $self->{_perfect_stem4} = $self->{_perfect_stem3};

    return $self;
}

sub imperative {
    my ($self) = @_;

    my $stem = $self->{_stem};

    $stem =~ s/д$/ж/;

    return ($self->_emphasize ($stem, -1),
	    $self->_emphasize ($stem . 'те', -2));
}

sub present_active_participle {
    return (undef) x 9;
}

sub adverbial_participle {
    return undef;
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
