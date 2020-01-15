#! /bin/false

package BGTrainer::Word::Verb::I_160;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::I_145);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    $self->{_present_stem2} = $self->{_stem} . 'я';

    $self->{_aorist_stem1} = $self->{_stem};
    $self->{_aorist_stem1} =~ s/е$/я/;
    $self->{_aorist_stem2} = $self->{_stem};
    $self->{_aorist_stem2} =~ s/е$/я/;
    undef $self->{_aorist_stresses};

    $self->{_imperfect_stem2} = $self->{_stem} . 'е';

    $self->{_perfect_stem1} = $self->{_aorist_stem1};
    $self->{_perfect_stem4} = $self->{_perfect_stem3} = $self->{_stem};

    undef $self->{_perfect_stresses};

    return $self;
}

sub verbal_noun {
    return (undef) x 4;
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
