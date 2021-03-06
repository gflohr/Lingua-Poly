#! /bin/false

package BGTrainer::Word::Verb::I_171;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::I_157);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    $self->{_aorist_stem1} = $self->{_stem};
    chop $self->{_aorist_stem1};
    $self->{_aorist_stem2} = $self->{_aorist_stem1};

    $self->{_perfect_stem1} = $self->{_aorist_stem1};
    $self->{_perfect_stem2} = $self->{_aorist_stem1};
    $self->{_perfect_stem3} = $self->{_aorist_stem1};
    $self->{_perfect_stem4} = $self->{_aorist_stem1};

    $self->{_gerund_stem} = $word;

    return $self;
}

sub past_passive_participle {
    require BGTrainer::Word::Verb::I_161_a;
    &BGTrainer::Word::Verb::I_161_a::past_passive_participle;
}

sub present_active_participle {
    return (undef) x 9;
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
