#! /bin/false

package BGTrainer::Word::PossessivePronoun::I_113;

use strict;

use utf8;

use base qw (BGTrainer::Word::PossessivePronoun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    return ($self->_emphasize ('техен', @stresses),
	    $self->_emphasize ('техния', @stresses),
	    $self->_emphasize ('техният', @stresses),
	    $self->_emphasize ('тяхна', @stresses),
	    $self->_emphasize ('тяхната', @stresses),
	    $self->_emphasize ('тяхно', @stresses),
	    $self->_emphasize ('тяхното', @stresses),
	    $self->_emphasize ('техни', @stresses),
	    $self->_emphasize ('техните', @stresses),
	    $self->_emphasize ('им', @stresses),
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
