#! /bin/false

package BGTrainer::Word::Verb::IV_144;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    my $pre = $word;
    $pre =~ s/ща$//;

    $self->{__pre} = $pre;

    return $self;
}

sub present {
    my ($self) = @_;

    my $pre = $self->{__pre};

    return ($self->_emphasize ($pre . 'ща', 1),
	    $self->_emphasize ($pre . 'щеш', 1),
	    $self->_emphasize ($pre . 'ще', 1),
	    $self->_emphasize ($pre . 'щем', 1),
	    $self->_emphasize ($pre . 'щете', 1),
	    $self->_emphasize ($pre . 'щат', 1));
}

sub past_aorist {
    my ($self) = @_;

    my $pre = $self->{__pre};

    return ($self->_emphasize ($pre . 'щях', 1),
	    [
	     $self->_emphasize ($pre . 'щя', 1),
	     $self->_emphasize ($pre . 'щеше', 1),
	     ],
	    [
	     $self->_emphasize ($pre . 'щя', 1),
	     $self->_emphasize ($pre . 'щеше', 1),
	     ],
	    $self->_emphasize ($pre . 'щяхме', 1),
	    $self->_emphasize ($pre . 'щяхте', 1),
	    $self->_emphasize ($pre . 'щяха', 1),
	    );
}

sub past_imperfect {
    my ($self) = @_;

    my $pre = $self->{__pre};

    return ($self->_emphasize ($pre . 'щях', 1),
	    $self->_emphasize ($pre . 'щеше', 1),
	    $self->_emphasize ($pre . 'щеше', 1),
	    $self->_emphasize ($pre . 'щяхме', 1),
	    $self->_emphasize ($pre . 'щяхте', 1),
	    $self->_emphasize ($pre . 'щяха', 1),
	    );
}

sub imperative {
    return undef, undef;
}

sub past_active_aorist_participle {
    my ($self) = @_;

    my $pre = $self->{__pre};

    return ($self->_emphasize ($pre . 'щял', 1),
	    $self->_emphasize ($pre . 'щелия', 1),
	    $self->_emphasize ($pre . 'щелият', 1),
	    $self->_emphasize ($pre . 'щяла', 1),
	    $self->_emphasize ($pre . 'щялата', 1),
	    $self->_emphasize ($pre . 'щяло', 1),
	    $self->_emphasize ($pre . 'щялото', 1),
	    $self->_emphasize ($pre . 'щели', 1),
	    $self->_emphasize ($pre . 'щелите', 1));
}

sub past_active_imperfect_participle {
    shift->past_active_aorist_participle;
}

sub past_passive_participle {
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
    undef;
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
