#! /bin/false

package BGTrainer::Word::IndefinitePronoun::I_122;

use strict;

use utf8;

use base qw (BGTrainer::Word::Pronoun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    return ($self->_emphasize ('нечий', @stresses),
	    $self->_emphasize (undef, @stresses),
	    $self->_emphasize (undef, @stresses),
	    $self->_emphasize (undef, @stresses),
	    $self->_emphasize ('нечия', @stresses),
	    $self->_emphasize ('нечие', @stresses),
	    $self->_emphasize ('нечии', @stresses),
	    );
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
