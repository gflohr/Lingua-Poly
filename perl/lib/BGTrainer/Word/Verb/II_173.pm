#! /bin/false

package BGTrainer::Word::Verb::II_173;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    my $stem = $word;
    $stem =~ s/(.)$//;

    $self->{_stem} = $stem;
    $self->{_present_stem1} = $stem . 'и';
    $self->{_present_stem2} = $stem . $1;

    $self->{_aorist_stem1} = $stem . 'и';
    $self->{_aorist_stem2} = $stem . 'и';

    $self->{_imperfect_stem1} = $stem . 'е';
    $self->{_imperfect_stem2} = $stem . 'е';

    $self->{_gerund_stem} = $stem . 'е';

    return $self;
}

sub verbal_noun {
    return undef, undef, undef, undef;
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
