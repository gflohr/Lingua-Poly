#! /bin/false

package BGTrainer::Word::Noun::II_41_a;

use strict;

use utf8;

use base qw (BGTrainer::Word::Noun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    my $stem = $word;
    $stem =~ s/а$//;

    return (
	    $self->_emphasize ($word, @stresses),
	    undef,
	    $self->_emphasize ($word . 'та', @stresses),
	    $self->_emphasize ($stem . 'и', @stresses),
	    $self->_emphasize ($stem . 'ите', @stresses),
	    undef,
	    $self->_emphasize ($stem . 'о', @stresses),
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
