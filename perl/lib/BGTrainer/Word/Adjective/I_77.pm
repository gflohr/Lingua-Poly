#! /bin/false

package BGTrainer::Word::Adjective::I_77;

use strict;

use utf8;

use base qw (BGTrainer::Word::Adjective);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    return ($self->_emphasize ($word, @stresses),
	    $self->_emphasize ($word . 'ия', @stresses),
	    $self->_emphasize ($word . 'ият', @stresses),
	    $self->_emphasize ($word . 'а', @stresses),
	    $self->_emphasize ($word . 'ата', @stresses),
	    $self->_emphasize ($word . 'е', @stresses),
	    $self->_emphasize ($word . 'ето', @stresses),
	    $self->_emphasize ($word . 'и', @stresses),
	    $self->_emphasize ($word . 'ите', @stresses),
	    $self->_emphasize ($word . 'и', @stresses),
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
