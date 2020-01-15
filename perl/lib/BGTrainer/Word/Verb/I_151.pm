#! /bin/false

package BGTrainer::Word::Verb::I_151;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::I_150);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    undef $self->{_aorist_stem2};
    $self->{_aorist_stem1} = $word;
    @{$self->{_aorist_stresses}} = @{$self->{_stresses}};
    --$self->{_aorist_stresses}->[-1] if $self->{_aorist_stresses}->[-1];

    $self->{_perfect_stem1} = 
	$self->{_perfect_stem3} = 
	$self->{_perfect_stem4} = $word;
    @{$self->{_perfect_stresses}} = @{$self->{_aorist_stresses}};

    $self->{_gerund_stem} = $word;
    $self->{_gerund_stem} =~ s/а$/е/;

    return $self;
}

sub past_active_imperfect_participle {
    &BGTrainer::Word::Verb::past_active_imperfect_participle;
}

sub present_active_participle {
    &BGTrainer::Word::Verb::present_active_participle;
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
