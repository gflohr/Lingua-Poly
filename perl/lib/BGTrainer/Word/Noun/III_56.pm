#! /bin/false

package BGTrainer::Word::Noun::III_56;

use strict;

use utf8;

use base qw (BGTrainer::Word::Noun);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    my $plural_stem = $word;
    $plural_stem =~ s/о$//;

    return (
	    $self->_emphasize ($word, -1),
	    undef,
	    $self->_emphasize ($word . 'то', -2),
	    [
	     $self->_emphasize ($plural_stem . 'а', -1),
	     $self->_emphasize ($plural_stem . 'е', -1),
	     ],
	    [
	    $self->_emphasize ($plural_stem . 'ата', -2),
	    $self->_emphasize ($plural_stem . 'ете', -2),
	     ],
	    undef,
	    undef
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

