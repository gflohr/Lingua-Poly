#! /bin/false

package BGTrainer::Word::Adjective::I_89;

use strict;

use utf8;

use base qw (BGTrainer::Word::Adjective);

sub none { 
    my ($self) = @_;
    
    my $word = $self->{_word};
    my @stresses = @{$self->{_stresses}};

    my $stem = $word;
    $stem =~ s/ия$//;

    return (undef,
	    $self->_emphasize ($stem . 'ия', @stresses),
	    $self->_emphasize ($stem . 'ият', @stresses),
	    undef,
	    $self->_emphasize ($stem . 'ата', @stresses),
	    undef,
	    $self->_emphasize ($stem . 'ото', @stresses),
	    undef,
	    $self->_emphasize ($stem . 'ите', @stresses),
	    undef,
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
