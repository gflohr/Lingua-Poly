#! /bin/false

package BGTrainer::Word::Verb::I_146;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::I_145_b);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    my $stem = $word;
    $stem =~ s/.$//;

    $self->{_stem} = $stem;

    undef $self->{_aorist_stresses};

    $self->{_imperfect_stem2} = $stem . 'е';

    $self->{_perfect_stem1} = $stem;
    $self->{_perfect_stem1} =~ s/й?.$/шъ/;
    $self->{_perfect_stem2} = $stem;
    $self->{_perfect_stem2} =~ s/й?.$/ш/;
    undef $self->{_perfect_stresses};

    undef $self->{_gerund_stem};

    return $self;
}

sub present_active_participle {
    return (undef, undef, undef,
	    undef, undef,
	    undef, undef,
	    undef, undef);
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
