#! /bin/false

package BGTrainer::Word::Verb::I_147;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::I_146);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    $self->{_present_stem1} = $self->{_stem};
    $self->{_present_stem1} =~ s/.(.)$/е${1}е/;

    undef $self->{_aorist_stresses};

    $self->{_perfect_stem1} = $self->{_stem};
    $self->{_perfect_stem1} .= 'ъ';
    $self->{_perfect_stem2} = $self->{_stem};
    $self->{_perfect_stem3} = $self->{_present_stem1};
    $self->{_perfect_stem3} =~ s/е$//;
    $self->{_perfect_stem4} = $self->{_perfect_stem3};
    undef $self->{_perfect_stresses};
    
    $self->{_imperfect_stem2} = $self->{_present_stem1};

    return $self;
}

sub imperative {
    my ($self) = @_;

    my $stem = $self->{_stem};
    $stem =~ s/.(.)$/е${1}/;

    return ($self->_emphasize ($stem),
	    $self->_emphasize ($stem . 'те'));
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
