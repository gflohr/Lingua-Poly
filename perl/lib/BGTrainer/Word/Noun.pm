#! /bin/false

package BGTrainer::Word::Noun;

use strict;

use utf8;

use base qw (BGTrainer::Word);
use Locale::TextDomain qw (net.guido-flohr.bgtrainer);

sub base_inflections {
    my ($self, $type) = @_;

    return qw (none);
}

sub features {
    my ($self) = @_;

    my @features = 
	(
     {
	 id => 'singular',
	 name => __"Singular",
	 proper_name => 'Единствено число',
     },
     {
	 id => 'singular_definite',
	 name => __"Singular with definite article",
	 proper_name => 'Единствено число, непълен член',
     },
     {
	 id => 'singular_definite_subject',
	 name => __"Singular with definite article as subject",
	 proper_name => 'Единствено число, пълен член',
     },
     {
	 id => 'plural',
	 name => __"Plural",
	 proper_name => 'Множествено число',
     },
     {
	 id => 'plural_definite',
	 name => __"Plural with definite article",
	 proper_name => 'Множествено число с определителен член',
     },
     {
	 id => 'counting_form',
	 name => __"Counting form",
	 proper_name => 'Бройната форма',
     },
     {
	 id => 'vocative',
	 name => __"Vocative",
	 proper_name => 'Звателна форма',
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

sub _getFeatureSingular {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[0]);
}

sub _getFeatureSingularDefinite {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[1]);
}

sub _getFeatureSingularDefiniteSubject {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[2]);
}

sub _getFeaturePlural {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[3]);
}

sub _getFeaturePluralDefinite {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[4]);
}

sub _getFeatureCountingForm {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[5]);
}

sub _getFeatureVocative {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[6]);
}

sub describeVariations {
    return [];
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
