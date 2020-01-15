#! /bin/false

package BGTrainer::Word::OrdinalNumber::I_141;

use strict;

use utf8;

use base qw (BGTrainer::Word::Number);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    my $stem = $word;
    $stem =~ s/и$//;

    return ($self->_emphasize ($word, @stresses),
	    $self->_emphasize ($stem . 'ия', @stresses),
	    $self->_emphasize ($stem . 'ият', @stresses),
	    $self->_emphasize ($stem . 'а', @stresses),
	    $self->_emphasize ($stem . 'ата', @stresses),
	    $self->_emphasize ($stem . 'о', @stresses),
	    $self->_emphasize ($stem . 'ото', @stresses),
	    $self->_emphasize ($stem . 'и', @stresses),
	    $self->_emphasize ($stem . 'ите', @stresses),
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
