#! /bin/false

package BGTrainer::Word::Verb::IV_142;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb);

sub present {
    my ($self) = @_;

    return ($self->_emphasize ('съм', 1),
	    $self->_emphasize ('си', 1),
	    $self->_emphasize ('е', 1),
	    $self->_emphasize ('сме', 1),
	    $self->_emphasize ('сте', 1),
	    $self->_emphasize ('са', 1));
}

sub past_aorist {
    my ($self) = @_;

    return ($self->_emphasize ('бях', 1),
	    [
	     $self->_emphasize ('бе', 1),
	     $self->_aux_beshe,
	     ],
	    [
	     $self->_emphasize ('бе', 1),
	     $self->_aux_beshe,
	     ],
	    $self->_emphasize ('бяхме', 1),
	    $self->_emphasize ('бяхте', 1),
	    $self->_emphasize ('бяха', 1));
}

sub past_imperfect {
    my ($self) = @_;

    return ($self->_emphasize ('бях', 1),
	    $self->_emphasize ('беше', 1),
	    $self->_emphasize ('беше', 1),
	    $self->_emphasize ('бяхме', 1),
	    $self->_emphasize ('бяхте', 1),
	    $self->_emphasize ('бяха', 1));
}

sub imperative {
    my ($self) = @_;

    return ($self->_emphasize ('бъди', -1),
	    $self->_emphasize ('бъдете', -2));
}

sub past_active_aorist_participle {
    my ($self) = @_;

    return ($self->_emphasize ('бил', 1),
	    $self->_emphasize ('билия', 1),
	    $self->_emphasize ('билият', 1),
	    $self->_emphasize ('била', 1),
	    $self->_emphasize ('билата', 1),
	    $self->_emphasize ('било', 1),
	    $self->_emphasize ('билото', 1),
	    $self->_emphasize ('били', 1),
	    $self->_emphasize ('билите', 1));
}

sub past_active_imperfect_participle {
    shift->past_active_aorist_participle;
}

sub past_passive_participle {
    my ($self) = @_;

    return (undef, undef, undef,
	    undef, undef, undef,
	    undef, undef, undef);
}

sub present_active_participle {
    return (undef, undef, undef,
	    undef, undef,
	    undef, undef,
	    undef, undef);
}

sub adverbial_participle {
    my ($self) = @_;

    return ([
	     $self->_emphasize ('бъдейки', 1),
	     $self->_emphasize ('бидейки', 1)
	     ]);
}

sub renarrative_passive {
    undef, undef, undef, undef, undef, undef, undef, undef;
}

sub verbal_noun {
    undef, undef, undef, undef;
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
