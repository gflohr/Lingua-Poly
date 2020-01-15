#! /bin/false

package BGTrainer::Word::Verb::I_166;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::I_164);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    $self->{_present_stem1} = $word;
    $self->{_present_stem1} =~ s/га$/же/;
    $self->{_present_stem2} = $word;

    $self->{_aorist_stem1} = $self->{_stem};
    $self->{_aorist_stem1} =~ s/г$/жа/;
    $self->{_aorist_stem2} = $self->{_aorist_stem1};

    $self->{_imperfect_stem1} = $self->{_imperfect_stem2} = 
	$self->{_present_stem1};

    $self->{_perfect_stem1} = $self->{_stem};
    $self->{_perfect_stem1} .= 'ъ';
    $self->{_perfect_stem2} = $self->{_stem};
    undef $self->{_perfect_stresses};

    $self->{_gerund_stem} = $self->{_present_stem1};

    return $self;
}

sub imperative {
    return (undef) x 2;
}

sub past_passive_participle {
    return (undef) x 9;
}

sub renarrative_passive {
    return (undef) x 8;
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
