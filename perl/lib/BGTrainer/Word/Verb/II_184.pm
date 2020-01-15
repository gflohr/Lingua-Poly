#! /bin/false

package BGTrainer::Word::Verb::II_184;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::II_174);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    $self->{_aorist_stem1} = $word;
    $self->{_aorist_stem1} =~ s/еля$/ля/;
    $self->{_aorist_stem2} = $self->{_aorist_stem1};

    $self->{_imperfect_stem1} = $word;
    $self->{_imperfect_stem1} =~ s/я$/е/;
    $self->{_imperfect_stem2} = $self->{_imperfect_stem1};

    $self->{_perfect_stem1} = $word;
    $self->{_perfect_stem1} =~ s/.(ля)$/$1/;

    $self->{_perfect_stem3} = $self->{_perfect_stem1};

    return $self;
}

sub past_passive_participle {
    my ($self) = @_;

    my $stem1 = $self->{_perfect_stem1} . 'н';
    my $stem2 = $self->{_perfect_stem1} . 'т';

    return (
	    [
	     $self->_emphasize ($stem1, -1),
	     $self->_emphasize ($stem2, -1),
	     ],
	    [
	     $self->_emphasize ($stem1 . 'ия', -3),
	     $self->_emphasize ($stem2 . 'ия', -3),
	     ],
	    [
	     $self->_emphasize ($stem1 . 'ият', -3),
	     $self->_emphasize ($stem2 . 'ият', -3),
	     ],
	    [
	     $self->_emphasize ($stem1 . 'а', -2),
	     $self->_emphasize ($stem2 . 'а', -2),
	     ],
	    [
	     $self->_emphasize ($stem1 . 'ата', -3),
	     $self->_emphasize ($stem2 . 'ата', -3),
	     ],
	    [
	     $self->_emphasize ($stem1 . 'о', -2),
	     $self->_emphasize ($stem2 . 'о', -2),
	     ],
	    [
	     $self->_emphasize ($stem1 . 'ото', -3),
	     $self->_emphasize ($stem2 . 'ото', -3),
	     ],
	    [
	     $self->_emphasize ($stem1 . 'и', -2),
	     $self->_emphasize ($stem2 . 'и', -2),
	     ],
	    [
	     $self->_emphasize ($stem1 . 'ите', -3),
	     $self->_emphasize ($stem2 . 'ите', -3),
	     ],
	    );
}

sub renarrative_passive {
    my ($self) = @_;

    my @participles = $self->past_passive_participle;

    return ([map { $_ . ' съм' } @{$participles[0]}],
	    [map { $_ . ' си' } @{$participles[0]}],
	    [map { $_ . ' е' } @{$participles[0]}],
	    [map { $_ . ' е' } @{$participles[3]}],
	    [map { $_ . ' е' } @{$participles[5]}],
	    [map { $_ . ' сме' } @{$participles[7]}],
	    [map { $_ . ' сте' } @{$participles[7]}],
	    [map { $_ . ' са' } @{$participles[7]}]);
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
