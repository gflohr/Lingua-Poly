#! /bin/false

package BGTrainer::Word::Verb::II_178;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::II_177);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    $self->{_imperfect_stem2} = $self->{_stem} . 'е';

    $self->{_perfect_stem1} = $word;
    $self->{_perfect_stem2} = $word;
    $self->{_perfect_stem3} = $word;
    $self->{_perfect_stem4} = $word;

    return $self;
}

sub past_passive_participle {
    return (undef) x 9;
}

sub present_active_participle {
    my ($self) = @_;

    my $stem = $self->{_stem} . 'а';
    my $stresses = $self->{_stresses};

    return ($self->_emphasize ($stem . 'щ', @$stresses),
	    $self->_emphasize ($stem . 'щия', @$stresses),
	    $self->_emphasize ($stem . 'щият', @$stresses),
	    $self->_emphasize ($stem . 'ща', @$stresses),
	    $self->_emphasize ($stem . 'щата', @$stresses),
	    $self->_emphasize ($stem . 'що', @$stresses),
	    $self->_emphasize ($stem . 'щото', @$stresses),
	    $self->_emphasize ($stem . 'щи', @$stresses),
	    $self->_emphasize ($stem . 'щите', @$stresses));
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
