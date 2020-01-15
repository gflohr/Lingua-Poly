#! /bin/false

package BGTrainer::Word::Adjective::I_83;

use strict;

use utf8;

use base qw (BGTrainer::Word::Adjective);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    my $stem1 = $word;
    $stem1 =~ s/я(.)ъ(.)$/е$1$2/;

    my $stem2 = $word;
    $stem2 =~ s/(.)ъ(.)$/$1$2/;

    return ($self->_emphasize ($word, @stresses),
	    $self->_emphasize ($stem1 . 'ия', @stresses),
	    $self->_emphasize ($stem1 . 'ият', @stresses),
	    $self->_emphasize ($stem2 . 'а', @stresses),
	    $self->_emphasize ($stem2 . 'ата', @stresses),
	    $self->_emphasize ($stem2 . 'о', @stresses),
	    $self->_emphasize ($stem2 . 'ото', @stresses),
	    $self->_emphasize ($stem1 . 'и', @stresses),
	    $self->_emphasize ($stem1 . 'ите', @stresses),
	    $self->_emphasize ($stem1 . 'и', @stresses),
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
