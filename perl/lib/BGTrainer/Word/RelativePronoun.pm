#! /bin/false

package BGTrainer::Word::RelativePronoun;

use strict;

use utf8;

use base qw (BGTrainer::Word::Pronoun);
use Locale::TextDomain qw (net.guido-flohr.bgtrainer);

sub features {
    my ($self) = @_;

    my @features = 
	(
      {
	 id => 'masculine_singular',
	 name => __"Masculine singular",
	 proper_name => 'мъжки род, единствено число',
     },
     {
	 id => 'accusative',
	 name => __"Accusative",
	 proper_name => 'винителен падеж',
     },
     {
	 id => 'dative',
	 name => __"Dative",
	 proper_name => 'дателен падеж',
     },
     {
	 id => 'dative_prepositional',
	 name => __"Dative, prepositional form",
	 proper_name => 'дателен падеж, предложена форма',
     },
     {
	 id => 'feminine_singular',
	 name => __"Feminine singular",
	 proper_name => 'женски род, единствено число',
     },
     {
	 id => 'neuter_singular',
	 name => __"Neuter singular",
	 proper_name => 'сreden род, единствено число',
     },
     {
	 id => 'plural',
	 name => __"Plural",
	 proper_name => 'множествено число',
     },
	 );
    
    return \@features;
}

sub __unfold {
    my ($self, $maybe_ref) = @_;

    if (!defined $maybe_ref) {
	return '-';
    } elsif (ref $maybe_ref) {
	return join '/', @$maybe_ref;
    } else {
	return $maybe_ref;
    }
}

sub _getFeatureMasculineSingular {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[0]);
}

sub _getFeatureAccusative {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[1]);
}

sub _getFeatureDative {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[2]);
}

sub _getFeatureDativePrepositional {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[3]);
}

sub _getFeatureFeminineSingular {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[4]);
}

sub _getFeatureNeuterSingular {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[5]);
}

sub _getFeaturePlural {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[6]);
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
