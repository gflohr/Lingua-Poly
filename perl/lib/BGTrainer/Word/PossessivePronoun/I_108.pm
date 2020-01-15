#! /bin/false

package BGTrainer::Word::PossessivePronoun::I_108;

use strict;

use utf8;

use base qw (BGTrainer::Word::PossessivePronoun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    return ($self->_emphasize ('свой', @stresses),
	    $self->_emphasize ('своя', @stresses),
	    $self->_emphasize ('своят', @stresses),
	    $self->_emphasize ('своя', @stresses),
	    $self->_emphasize ('своята', @stresses),
	    $self->_emphasize ('свое', @stresses),
	    $self->_emphasize ('своето', @stresses),
	    $self->_emphasize ('свои', @stresses),
	    $self->_emphasize ('своите', @stresses),
	    $self->_emphasize ('си', @stresses),
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
