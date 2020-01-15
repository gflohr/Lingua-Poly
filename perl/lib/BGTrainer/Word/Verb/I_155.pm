#! /bin/false

package BGTrainer::Word::Verb::I_155;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::I_146);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    $self->{_aorist_stem1} = $self->{_stem};
    $self->{_aorist_stem1} =~ s/ч$/ка/;
    $self->{_aorist_stem2} = $self->{_stem};
    $self->{_aorist_stem2} =~ s/ч$/ка/;
    undef $self->{_aorist_stresses};

    $self->{_perfect_stem2} = $self->{_perfect_stem1} = $self->{_aorist_stem1};

    $self->{_gerund_stem} = $self->{_stem} . 'е';

    return $self;
}

sub past_passive_participle {
    &BGTrainer::Word::Verb::past_passive_participle;
}

sub present_active_participle {
    &BGTrainer::Word::Verb::present_active_participle;
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
