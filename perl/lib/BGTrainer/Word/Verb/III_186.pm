#! /bin/false

package BGTrainer::Word::Verb::III_186;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    my $stem = $word;
    $stem =~ s/(.)$//;

    $self->{_stem} = $self->{_gerund_stem} = $stem;

    return $self;
}

sub present {
    my ($self) = @_;

    my $stresses = $self->{_present_stresses} || $self->{_stresses};
   
    my $stem1 = $self->{_present_stem1} || $self->{_stem};
    my $stem2 = $self->{_present_stem2} || $self->{_stem};

    return ($self->_emphasize ($self->{_word}),
	    $self->_emphasize ($stem1 . 'ш'),
	    $self->_emphasize ($stem1),
	    $self->_emphasize ($stem1 . 'ме'),
	    $self->_emphasize ($stem1 . 'те'),
	    $self->_emphasize ($stem2 . 'т'));
}

sub past_passive_participle {
    my ($self) = @_;

    my @aorist = $self->past_aorist;

    my $stem = $aorist[1];

    return ($stem . 'н',
	    $stem . 'ния',
	    $stem . 'ният',
	    $stem . 'на',
	    $stem . 'ната',
	    $stem . 'но',
	    $stem . 'ното',
	    $stem . 'ни',
	    $stem . 'ните');
}

sub verbal_noun {
    return undef, undef, undef, undef;
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
