#! /bin/false

package BGTrainer::Word::Verb::I_161_a;

use strict;

use utf8;

use BGTrainer::Util qw (bg_count_syllables);

use base qw (BGTrainer::Word::Verb::I_161);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    return $self;
}

sub past_passive_participle {
    my ($self) = @_;

    my @aorist = $self->past_aorist;

    my $stem1 = $aorist[1];
    my $stem2 = $stem1;
    
    my $stem3 = $stem1;
    $stem3 =~ s/[^\x00-\xff]((?:[\x00-\xff])*)$/е$1/
	if ($self->isa ('BGTrainer::Word::Verb::I_164'));

    if (1 == bg_count_syllables $stem2) {
	$stem2 .= 'ю';
	$stem2 = $self->_emphasize ($stem2, 1);
	chop $stem2;
    }

    if (1 == bg_count_syllables $stem3) {
	$stem3 .= 'ю';
	$stem3 = $self->_emphasize ($stem3, 1);
	chop $stem3;
    }

    return ($stem1 . 'т',
	    $stem2 . 'тия',
	    $stem2 . 'тият',
	    $stem2 . 'та',
	    $stem2 . 'тата',
	    $stem2 . 'то',
	    $stem2 . 'тото',
	    $stem3 . 'ти',
	    $stem3 . 'тите');
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
