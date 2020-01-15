#! /bin/false

package BGTrainer::Word::Verb::I_145;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    my $stem = $word;
    $stem =~ s/.$//;

    $self->{_stem} = $stem;
    $self->{_present_stem1} = $stem . 'е';
    $self->{_present_stem2} = $stem . 'а';

    @{$self->{_aorist_stresses}} = @{$self->{_stresses}};
    --$self->{_aorist_stresses}->[-1] if $self->{_aorist_stresses}->[-1];
    $self->{_aorist_stem2} = $stem . 'о';

    # FIXME: Sometimes 'а' ...
    $self->{_imperfect_stem2} = $stem . 'я';

    $self->{_perfect_stem1} = $stem;
    $self->{_perfect_stem1} =~ s/.$//;
    @{$self->{_perfect_stresses}} = @{$self->{_stresses}};
    --$self->{_perfect_stresses}->[-1] if $self->{_perfect_stresses}->[-1];

    $self->{_gerund_stem} = $self->{_present_stem1};

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
