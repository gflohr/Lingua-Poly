#! /bin/false

package BGTrainer::Word::LastName::I_202;

use strict;

use utf8;

use base qw (BGTrainer::Word::LastName);

sub none { 
    my ($self) = @_;
    
    my $stem = $self->{_word};
    chop $stem;
    my @stresses = @{$self->{_stresses}};

    return ($self->_emphasize ($stem . 'и', @stresses),
	    $self->_emphasize ($stem . 'а', @stresses)
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
