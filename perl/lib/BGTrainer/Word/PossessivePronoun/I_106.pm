#! /bin/false

package BGTrainer::Word::PossessivePronoun::I_106;

use strict;

use utf8;

use base qw (BGTrainer::Word::PossessivePronoun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    return ($self->_emphasize ('мой', @stresses),
	    $self->_emphasize ('моя', @stresses),
	    $self->_emphasize ('моят', @stresses),
	    $self->_emphasize ('моя', @stresses),
	    $self->_emphasize ('моята', @stresses),
	    $self->_emphasize ('мое', @stresses),
	    $self->_emphasize ('моето', @stresses),
	    $self->_emphasize ('мои', @stresses),
	    $self->_emphasize ('моите', @stresses),
	    $self->_emphasize ('ми', @stresses),
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
