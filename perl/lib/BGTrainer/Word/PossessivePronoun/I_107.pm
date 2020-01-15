#! /bin/false

package BGTrainer::Word::PossessivePronoun::I_107;

use strict;

use utf8;

use base qw (BGTrainer::Word::PossessivePronoun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    return ($self->_emphasize ('твой', @stresses),
	    $self->_emphasize ('твоя', @stresses),
	    $self->_emphasize ('твоят', @stresses),
	    $self->_emphasize ('твоя', @stresses),
	    $self->_emphasize ('твоята', @stresses),
	    $self->_emphasize ('твое', @stresses),
	    $self->_emphasize ('твоето', @stresses),
	    $self->_emphasize ('твои', @stresses),
	    $self->_emphasize ('твоите', @stresses),
	    $self->_emphasize ('ти', @stresses),
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
