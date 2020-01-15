#! /bin/false

package BGTrainer::Word::PossessivePronoun::I_111;

use strict;

use utf8;

use base qw (BGTrainer::Word::PossessivePronoun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    return ($self->_emphasize ('наш', @stresses),
	    $self->_emphasize ('нашия', @stresses),
	    $self->_emphasize ('нашият', @stresses),
	    $self->_emphasize ('наша', @stresses),
	    $self->_emphasize ('нашата', @stresses),
	    $self->_emphasize ('наше', @stresses),
	    $self->_emphasize ('нашето', @stresses),
	    $self->_emphasize ('наши', @stresses),
	    $self->_emphasize ('нашите', @stresses),
	    $self->_emphasize ('ни', @stresses),
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
