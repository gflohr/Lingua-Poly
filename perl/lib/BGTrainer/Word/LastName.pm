#! /bin/false

package BGTrainer::Word::LastName;

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
	 id => 'masculine',
	 name => __"Masculine",
	 proper_name => 'Мъжко',
     },
     {
	 id => 'feminine',
	 name => __"Feminine",
	 proper_name => 'Женско',
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

sub _getFeatureMasculine {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[0]);
}

sub _getFeatureFeminine {
    my ($self) = @_;

    my @raw_forms = $self->none;
    return $self->__unfold ($raw_forms[1]);
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
