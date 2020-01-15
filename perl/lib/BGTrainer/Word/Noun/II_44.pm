#! /bin/false

package BGTrainer::Word::Noun::II_44;

use strict;

use utf8;

use base qw (BGTrainer::Word::Noun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    my $plural1 = $word;
    $plural1 =~ s/а$/е/;

    my $plural2 = $word;
    $plural2 =~ s/а$/и/;

    my $vocative = $word;
    $vocative =~ s/а$/о/;

    return (
	    $self->_emphasize ($word, @stresses),
	    undef,
	    $self->_emphasize ($word . 'та', @stresses),
	    [
	     $self->_emphasize ($plural1, -2),
	     $self->_emphasize ($plural2, -2),
	     ],
	    [
	     $self->_emphasize ($plural1 . 'те', -3),
	     $self->_emphasize ($plural2 . 'те', -3),
	     ],
	    undef,
	    $self->_emphasize ($vocative, @stresses),
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
