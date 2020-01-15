#! /bin/false

package BGTrainer::Word::DemonstrativePronoun::I_104;

use strict;

use utf8;

use base qw (BGTrainer::Word::DemonstrativePronoun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    return ($self->_emphasize ('толкав', @stresses),
	    $self->_emphasize ('толкавия', @stresses),
	    $self->_emphasize ('толкавият', @stresses),
	    $self->_emphasize ('толкава', @stresses),
	    $self->_emphasize ('толкавата', @stresses),
	    $self->_emphasize ('толкаво', @stresses),
	    $self->_emphasize ('толкавото', @stresses),
	    $self->_emphasize ('толкави', @stresses),
	    $self->_emphasize ('толкавите', @stresses),
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
