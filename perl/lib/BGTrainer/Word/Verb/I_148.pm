#! /bin/false

package BGTrainer::Word::Verb::I_148;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::I_145);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    $self->{_present_stem1} = $self->{_stem};
    $self->{_present_stem1} =~ s/к$/че/;

    $self->{_imperfect_stem2} = $self->{_stem};
    $self->{_imperfect_stem2} =~ s/к$/ча/;

    $self->{_imperative_stem} = $self->{_stem};
    $self->{_imperative_stem} =~ s/к$/чи/;

    $self->{_perfect_stem1} = $self->{_perfect_stem2} = $self->{_stem};
    $self->{_perfect_stem1} .= 'ъ';

    undef $self->{_gerund_stem};

    return $self;
}

sub past_active_imperfect_participle {
    my ($self) = @_;

    my @imperfect = $self->past_imperfect;

    my $stem1 = $imperfect[0];
    $stem1 =~ s/х$//;

    return ($stem1 . 'л',
	    $stem1 . 'лия',
	    $stem1 . 'лият',
	    $stem1 . 'ла',
	    $stem1 . 'лата',
	    $stem1 . 'ло',
	    $stem1 . 'лото',
	    $stem1 . 'ли',
	    $stem1 . 'лите');
}

sub present_active_participle {
    undef, undef, undef,
    undef, undef,
    undef, undef,
    undef, undef;
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
