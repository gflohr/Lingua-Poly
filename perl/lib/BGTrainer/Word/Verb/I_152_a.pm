#! /bin/false

package BGTrainer::Word::Verb::I_152_a;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::I_152);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    $self->{_present_stem1} = $self->{_stem};
    $self->{_present_stem1} =~ s/я(..)$/е${1}е/;
    $self->{_present_stem2} = $self->{_stem};
    $self->{_present_stem2} =~ s/я(..)$/е${1}а/;

    $self->{_aorist_stem2} = $self->{_stem} . 'а';

    $self->{_imperfect_stem1} = $self->{_imperfect_stem2} =
	$self->{_present_stem1};

    $self->{_imperative_stem} = $self->{_present_stem1};

    return $self;
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
