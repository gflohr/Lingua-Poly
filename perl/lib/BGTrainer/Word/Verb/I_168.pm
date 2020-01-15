#! /bin/false

package BGTrainer::Word::Verb::I_168;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::I_145);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    $self->{_stem} .= 'д';
    $self->{_present_stem1} = $self->{_stem} . 'е';
    $self->{_present_stem2} = $self->{_stem} . 'а';

    $self->{_aorist_stem2} = $self->{_stem} . 'о';
    @{$self->{_aorist_stresses}} = @{$self->{_stresses}};

    $self->{_stresses}->[-1]++
	if $self->{_stresses}->[-1];

    $self->{_imperfect_stem2} = $self->{_stem} . 'я';

    $self->{_perfect_stem1} = $self->{_stem};
    chop $self->{_perfect_stem1};
    $self->{_perfect_stem2} = $self->{_perfect_stem1};
    $self->{_perfect_stem3} = $self->{_perfect_stem1};
    $self->{_perfect_stem4} = $self->{_perfect_stem1};
    $self->{_perfect_stresses} = $self->{_aorist_stresses};

    undef $self->{_gerund_stem};

    return $self;
}

sub imperative {
    my ($self) = @_;

    my $stem = $self->{_stem};
    chop $stem;

    my $sg_end = 'й';
    my $pl_end = 'йте';

    return ($self->_emphasize ($stem . $sg_end, -1),
	    $self->_emphasize ($stem . $pl_end, -2));
}

sub present_active_participle {
    return (undef) x 9;
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
