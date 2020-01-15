#! /bin/false

package BGTrainer::Word::PossessivePronoun::I_112;

use strict;

use utf8;

use base qw (BGTrainer::Word::PossessivePronoun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    return ($self->_emphasize ('ваш', @stresses),
	    $self->_emphasize ('вашия', @stresses),
	    $self->_emphasize ('вашият', @stresses),
	    $self->_emphasize ('ваша', @stresses),
	    $self->_emphasize ('вашата', @stresses),
	    $self->_emphasize ('ваше', @stresses),
	    $self->_emphasize ('вашето', @stresses),
	    $self->_emphasize ('ваши', @stresses),
	    $self->_emphasize ('вашите', @stresses),
	    $self->_emphasize ('ви', @stresses),
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
