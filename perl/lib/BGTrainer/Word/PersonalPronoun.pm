#! /bin/false

package BGTrainer::Word::PersonalPronoun;

use strict;

use utf8;

use base qw (BGTrainer::Word::Pronoun);
use Locale::TextDomain qw (net.guido-flohr.bgtrainer);

sub features {
    my ($self) = @_;

    my @features = 
	(
     {
	 id => 'nominative',
	 name => __"Nominative",
	 proper_name => 'именителен падеж',
     },
     {
	 id => 'accusative',
	 name => __"Accusative",
	 proper_name => 'винителен падеж',
     },
     {
	 id => 'accusative_short',
	 name => __"Accusative, short form",
	 proper_name => 'винителен падеж, кратка форма',
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
	 id => 'dative_short',
	 name => __"Dative, short form",
	 proper_name => 'дателен падеж, кратка форма',
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

sub _getFeatureNominative {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[0]);
}

sub _getFeatureAccusative {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[1]);
}

sub _getFeatureAccusativeShort {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[2]);
}

sub _getFeatureDative {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[3]);
}

sub _getFeatureDativePrepositional {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[4]);
}

sub _getFeatureDativeShort {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[5]);
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
