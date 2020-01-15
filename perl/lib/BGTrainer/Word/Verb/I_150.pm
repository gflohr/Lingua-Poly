#! /bin/false

package BGTrainer::Word::Verb::I_150;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::I_145);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    $self->{_stem} = $word;

    $self->{_aorist_stem1} = $word;
    $self->{_aorist_stem1} =~ s/а$/я/;
    $self->{_aorist_stem2} = $self->{_aorist_stem1};
    undef $self->{_aorist_stresses};

    $self->{_perfect_stem1} = $self->{_aorist_stem1};
    $self->{_perfect_stem3} = $word;
    $self->{_perfect_stem3} =~ s/а$/е/;
    $self->{_perfect_stem4} = $self->{_perfect_stem3};
    undef $self->{_perfect_stresses};

    undef $self->{_gerund_stem};

    return $self;
}

sub past_active_imperfect_participle {
    shift->past_active_aorist_participle;
}

sub present_active_participle {
    undef, undef, undef, undef,
    undef, undef, undef, undef, undef;
}

sub verbal_noun {
    undef, undef, undef, undef;
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
