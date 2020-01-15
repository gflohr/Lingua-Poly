#! /bin/false

package BGTrainer::Word::PossessivePronoun::I_110;

use strict;

use utf8;

use base qw (BGTrainer::Word::PossessivePronoun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    return ($self->_emphasize ('неин', @stresses),
	    $self->_emphasize ('нейния', @stresses),
	    $self->_emphasize ('нейният', @stresses),
	    $self->_emphasize ('нейна', @stresses),
	    $self->_emphasize ('нейната', @stresses),
	    $self->_emphasize ('нейно', @stresses),
	    $self->_emphasize ('нейното', @stresses),
	    $self->_emphasize ('нейни', @stresses),
	    $self->_emphasize ('нейните', @stresses),
	    $self->_emphasize ('и', @stresses),
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
