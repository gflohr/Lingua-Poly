#! /bin/false

package BGTrainer::Word::SummativePronoun::I_127;

use strict;

use utf8;

use base qw (BGTrainer::Word::Pronoun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    return ($self->_emphasize ('всякой', @stresses),
	    $self->_emphasize (undef, @stresses),
	    $self->_emphasize (undef, @stresses),
	    $self->_emphasize ('всякого', @stresses),
	    $self->_emphasize ('всякому', @stresses),
	    $self->_emphasize ('всякого', @stresses),
	    $self->_emphasize ('всякоя', @stresses),
	    $self->_emphasize (undef, @stresses),
	    $self->_emphasize ('всякое', @stresses),
	    $self->_emphasize (undef, @stresses),
	    $self->_emphasize ('всякои', @stresses),
	    $self->_emphasize (undef, @stresses),
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
