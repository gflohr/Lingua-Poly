#! /bin/false

package BGTrainer::Word::Verb::I_146_a;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::I_146);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    @{$self->{_aorist_stresses}} = @{$self->{_stresses}};
    ++$self->{_aorist_stresses}->[-1] if $self->{_aorist_stresses}->[-1];

    @{$self->{_perfect_stresses}} = @{$self->{_stresses}};
    ++$self->{_perfect_stresses}->[-1] if $self->{_perfect_stresses}->[-1];

    return $self;
}

# FIXME! What is the imperative of the derived verbs?
sub imperative {
    my ($self) = @_;

    return ($self->_emphasize ('ела', -1),
	    $self->_emphasize ('елате', -2));
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
