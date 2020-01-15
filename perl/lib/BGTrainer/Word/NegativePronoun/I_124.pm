#! /bin/false

package BGTrainer::Word::NegativePronoun::I_124;

use strict;

use utf8;

use base qw (BGTrainer::Word::Pronoun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    return ($self->_emphasize ('никой', @stresses),
	    $self->_emphasize ('никого', @stresses),
	    $self->_emphasize ('никому', @stresses),
	    $self->_emphasize ('никого', @stresses),
	    $self->_emphasize ('никоя', @stresses),
	    $self->_emphasize ('никое', @stresses),
	    $self->_emphasize ('никои', @stresses),
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
