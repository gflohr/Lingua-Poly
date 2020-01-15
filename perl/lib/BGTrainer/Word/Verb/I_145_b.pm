#! /bin/false

package BGTrainer::Word::Verb::I_145_b;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::I_145_a);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    $self->{_perfect_stem1} = $self->{_stem};
    $self->{_perfect_stem1} =~ s/.$/ъ/;
    $self->{_perfect_stem2} = $self->{_stem};
    $self->{_perfect_stem2} =~ s/.$//;

    return $self;
}

sub past_passive_participle {
    undef, undef, undef, undef, undef, undef, undef, undef, undef;
}

sub renarrative_passive {
    undef, undef, undef, undef, undef, undef, undef, undef;
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
