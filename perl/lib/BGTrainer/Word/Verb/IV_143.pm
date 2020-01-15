#! /bin/false

package BGTrainer::Word::Verb::IV_143;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    my $pre = $word;
    $pre =~ s/бъда$//;

    $self->{__pre} = $pre;

    return $self;
}

sub present {
    my ($self) = @_;

    my $pre = $self->{__pre};

    return ($self->_emphasize ($pre . 'бъда', 1),
	    $self->_emphasize ($pre . 'бъдеш', 1),
	    $self->_emphasize ($pre . 'бъде', 1),
	    $self->_emphasize ($pre . 'бъдем', 1),
	    $self->_emphasize ($pre . 'бъдете', 1),
	    $self->_emphasize ($pre . 'бъдат', 1));
}

sub past_aorist {
    my ($self) = @_;

    my $pre = $self->{__pre};

    return ([
	     $self->_emphasize ($pre . 'бих', 1),
	     $self->_emphasize ($pre . 'бидох', 1),
	     ],
	    [
	     $self->_emphasize ($pre . 'би', 1),
	     $self->_emphasize ($pre . 'биде', 1),
	     ],
	    [
	     $self->_emphasize ($pre . 'би', 1),
	     $self->_emphasize ($pre . 'биде', 1),
	     ],
	    [
	     $self->_emphasize ($pre . 'бихме', 1),
	     $self->_emphasize ($pre . 'бидохме', 1),
	     ],
	    [
	     $self->_emphasize ($pre . 'бихте', 1),
	     $self->_emphasize ($pre . 'бидохте', 1),
	     ],
	    [
	     $self->_emphasize ($pre . 'биха', 1),
	     $self->_emphasize ($pre . 'бидоха', 1),
	    ]);
}

sub past_imperfect {
    my ($self) = @_;

    my $pre = $self->{__pre};

    return ([
	     $self->_emphasize ($pre . 'бъдех', 1),
	     $self->_emphasize ($pre . 'бях', 1),
	     ],
	    [
	     $self->_emphasize ($pre . 'бъдеше', 1),
	     $self->_emphasize ($pre . 'беше', 1),
	     ],
	    [
	     $self->_emphasize ($pre . 'бъдеше', 1),
	     $self->_emphasize ($pre . 'беше', 1),
	     ],
	    [
	     $self->_emphasize ($pre . 'бъдехме', 1),
	     $self->_emphasize ($pre . 'бяхме', 1),
	     ],
	    [
	     $self->_emphasize ($pre . 'бъдехте', 1),
	     $self->_emphasize ($pre . 'бяхте', 1),
	     ],
	    [
	     $self->_emphasize ($pre . 'бъдеха', 1),
	     $self->_emphasize ($pre . 'бяха', 1),
	    ]);
}

sub imperative {
    my ($self) = @_;

    my $pre = $self->{__pre};

    return ($self->_emphasize ($pre . 'бъди', 1),
	    $self->_emphasize ($pre . 'бъдете', 1));
}

sub past_active_aorist_participle {
    my ($self) = @_;

    my $pre = $self->{__pre};

    return ($self->_emphasize ($pre . 'бил', 1),
	    $self->_emphasize ($pre . 'билия', 1),
	    $self->_emphasize ($pre . 'билият', 1),
	    $self->_emphasize ($pre . 'била', 1),
	    $self->_emphasize ($pre . 'билата', 1),
	    $self->_emphasize ($pre . 'било', 1),
	    $self->_emphasize ($pre . 'билото', 1),
	    $self->_emphasize ($pre . 'били', 1),
	    $self->_emphasize ($pre . 'билите', 1));
}

sub past_active_imperfect_participle {
    my ($self) = @_;

    my $pre = $self->{__pre};

    return ($self->_emphasize ($pre . 'бъдел', 1),
	    $self->_emphasize ($pre . 'бъделия', 1),
	    $self->_emphasize ($pre . 'бъделият', 1),
	    $self->_emphasize ($pre . 'бъдела', 1),
	    $self->_emphasize ($pre . 'бъделата', 1),
	    $self->_emphasize ($pre . 'бъдело', 1),
	    $self->_emphasize ($pre . 'бъделото', 1),
	    $self->_emphasize ($pre . 'бъдели', 1),
	    $self->_emphasize ($pre . 'бъделите', 1));
}

sub past_passive_participle {
    my ($self) = @_;

    my $pre = $self->{__pre};

    return (undef, undef, undef,
	    undef, undef, undef,
	    undef, undef, undef);
}

sub present_active_participle {
    my ($self) = @_;

    my $pre = $self->{__pre};

    return ($self->_emphasize ($pre . 'бъдещ', 1),
	    $self->_emphasize ($pre . 'бъдещия', 1),
	    $self->_emphasize ($pre . 'бъдещият', 1),
	    $self->_emphasize ($pre . 'бъдеща', 1),
	    $self->_emphasize ($pre . 'бъдещата', 1),
	    $self->_emphasize ($pre . 'бъдещо', 1),
	    $self->_emphasize ($pre . 'бъдещото', 1),
	    $self->_emphasize ($pre . 'бъдещи', 1),
	    $self->_emphasize ($pre . 'бъдещите', 1));
}

sub adverbial_participle {
    my ($self) = @_;

    my $pre = $self->{__pre};

    return ([
	     $self->_emphasize ($pre . 'бъдейки', 1),
	     $self->_emphasize ($pre . 'бидейки', 1)
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
