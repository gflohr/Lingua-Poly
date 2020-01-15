#! /bin/false

package BGTrainer::Word::Verb::I_149;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::I_148);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    $self->{_aorist_stem2} = $self->{_stem};
    $self->{_aorist_stem2} =~ s/ек$/яко/;

    $self->{_perfect_stem1} = $self->{_stem};
    $self->{_perfect_stem1} =~ s/ек$/якъ/;
    $self->{_perfect_stem3} = $self->{_stem};
    $self->{_perfect_stem2} = $self->{_stem};
    $self->{_perfect_stem2} =~ s/ек$/як/;
    $self->{_perfect_stem4} = $self->{_perfect_stem3};

    return $self;
}

sub past_active_imperfect_participle {
    my ($self) = @_;

    my @imperfect = $self->past_imperfect;

    my $stem1 = $imperfect[0];
    $stem1 =~ s/х$//;
    my $stem2 = $imperfect[1];
    $stem2 =~ s/ше$//;

    return ($stem1 . 'л',
	    $stem2 . 'лия',
	    $stem2 . 'лият',
	    $stem1 . 'ла',
	    $stem1 . 'лата',
	    $stem1 . 'ло',
	    $stem1 . 'лото',
	    $stem2 . 'ли',
	    $stem2 . 'лите');
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
