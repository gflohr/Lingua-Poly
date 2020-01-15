#! /bin/false

package BGTrainer::Word::Verb::II_180;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::II_173);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    $self->{_aorist_stem2} = $word;
    $self->{_aorist_stem1} = $word;

    $self->{_imperfect_stem2} = $self->{_stem} . 'я';
    
    $self->{_perfect_stem4} = $word;

    return $self;
}

sub past_active_imperfect_participle {
    shift->past_active_aorist_participle;
}

sub past_passive_participle {
    return (undef) x 9;
}

sub renarrative_passive {
    return (undef) x 8;
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
