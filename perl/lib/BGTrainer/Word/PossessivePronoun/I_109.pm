#! /bin/false

package BGTrainer::Word::PossessivePronoun::I_109;

use strict;

use utf8;

use base qw (BGTrainer::Word::PossessivePronoun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    return ($self->_emphasize ('негов', @stresses),
	    $self->_emphasize ('неговия', @stresses),
	    $self->_emphasize ('неговият', @stresses),
	    $self->_emphasize ('негова', @stresses),
	    $self->_emphasize ('неговата', @stresses),
	    $self->_emphasize ('негово', @stresses),
	    $self->_emphasize ('неговото', @stresses),
	    $self->_emphasize ('негови', @stresses),
	    $self->_emphasize ('неговите', @stresses),
	    $self->_emphasize ('му', @stresses),
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
