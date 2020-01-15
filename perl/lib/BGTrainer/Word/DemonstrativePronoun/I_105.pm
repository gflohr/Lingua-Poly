#! /bin/false

package BGTrainer::Word::DemonstrativePronoun::I_105;

use strict;

use utf8;

use base qw (BGTrainer::Word::DemonstrativePronoun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    return ($self->_emphasize ('инакъв', @stresses),
	    $self->_emphasize ('инаквия', @stresses),
	    $self->_emphasize ('инаквият', @stresses),
	    $self->_emphasize ('инаква', @stresses),
	    $self->_emphasize ('инаквата', @stresses),
	    $self->_emphasize ('инакво', @stresses),
	    $self->_emphasize ('инаквото', @stresses),
	    $self->_emphasize ('инакви', @stresses),
	    $self->_emphasize ('инаквите', @stresses),
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
