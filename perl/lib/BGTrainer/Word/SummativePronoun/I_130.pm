#! /bin/false

package BGTrainer::Word::SummativePronoun::I_130;

use strict;

use utf8;

use base qw (BGTrainer::Word::Pronoun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    return ($self->_emphasize (undef, @stresses),
	    $self->_emphasize ('всичкия', @stresses),
	    $self->_emphasize ('всичкият', @stresses),
	    $self->_emphasize (undef, @stresses),
	    $self->_emphasize (undef, @stresses),
	    $self->_emphasize (undef, @stresses),
	    $self->_emphasize ('всичка', @stresses),
	    $self->_emphasize ('всичката', @stresses),
	    $self->_emphasize ('всичко', @stresses),
	    $self->_emphasize ('всичкото', @stresses),
	    $self->_emphasize ('всички', @stresses),
	    $self->_emphasize ('всичките', @stresses),
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
