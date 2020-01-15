#! /bin/false

package BGTrainer::Word::Verb;

use strict;

use utf8;

use base qw (BGTrainer::Word);

use Locale::TextDomain qw (net.guido-flohr.bgtrainer);

use BGTrainer::Util qw (bg_count_syllables);

sub base_inflections {
    my ($self, $type) = @_;

    return qw (present past_aorist past_imperfect imperative
	       past_active_aorist_participle past_active_imperfect_participle
	       past_passive_participle present_active_participle
	       adverbial_participle verbal_noun);
}

sub features {
    my ($self) = @_;

    my @features;
    
    push @features, {
	id => 'present',
	name => __"Present tense",
	proper_name => 'сегашно време',
    } if ($self->present)[0];

    push @features, {
	id => 'aorist',
	name => __"Past aorist tense",
	proper_name => 'минало свършено време',
    } if ($self->past_aorist)[0];
    
    push @features, {
	id => 'imperfect',
	name => __"Past imperfect tense",
	proper_name => 'минало несвършено време',
    } if ($self->past_imperfect)[0];
    
    push @features, {
	id => 'present_active_participle',
	name => __"Present active participle",
	proper_name => 'сегашно деятелно причастие',
    } if ($self->present_active_participle)[0];
    
    push @features, {
	id => 'past_active_aorist_participle',
	name => __"Past active aorist participle",
	proper_name => 'минало свършено деятелно причастие',
    } if ($self->past_active_aorist_participle)[0];
    
    push @features, {
	id => 'past_active_imperfect_participle',
	name => __"Past active imperfect participle",
	proper_name => 'минало несвършено деятелно причастие',
    } if ($self->past_active_imperfect_participle)[0];
    
    push @features, {
	id => 'past_passive_participle',
	name => __"Past passive participle",
	proper_name => 'минало страдателно причастие',
    } if ($self->past_passive_participle)[0];
    
    push @features, {
	id => 'verbal_noun',
	name => __"Verbal noun",
	proper_name => 'отглаголно съществително',
    } if ($self->verbal_noun)[0];
    
    push @features, {
	id => 'imperative',
	name => __"Imperative",
	proper_name => 'повелително наклонение',
    } if ($self->imperative)[0];
    
    push @features, {
	id => 'adverbial_participle',
	name => __"Adverbial participle",
	proper_name => 'деепричастие',
    } if ($self->adverbial_participle)[0];
    
    return \@features;
}

sub _getFeaturePresent {
    my ($self) = @_;

    my @raw_forms = map { $self->__unfold ($_) } $self->present;
    
    my $nie = $self->_pronoun_nie;
    my $vie = $self->_pronoun_vie;

    return <<EOF;
аз $raw_forms[0]
ти $raw_forms[1]
той $raw_forms[2]
тя $raw_forms[2]
тo $raw_forms[2]
$nie $raw_forms[3]
$vie $raw_forms[4]
те $raw_forms[5]
EOF
}

sub _getFeatureAorist {
    my ($self) = @_;

    my @raw_forms = map { $self->__unfold ($_) } $self->past_aorist;
    
    my $nie = $self->_pronoun_nie;
    my $vie = $self->_pronoun_vie;

    return <<EOF;
аз $raw_forms[0]
ти $raw_forms[1]
той $raw_forms[2]
тя $raw_forms[2]
тo $raw_forms[2]
$nie $raw_forms[3]
$vie $raw_forms[4]
те $raw_forms[5]
EOF
}

sub _getFeatureImperfect {
    my ($self) = @_;

    my @raw_forms = map { $self->__unfold ($_) } $self->past_imperfect;
    
    my $nie = $self->_pronoun_nie;
    my $vie = $self->_pronoun_vie;

    return <<EOF;
аз $raw_forms[0]
ти $raw_forms[1]
той $raw_forms[2]
тя $raw_forms[2]
тo $raw_forms[2]
$nie $raw_forms[3]
$vie $raw_forms[4]
те $raw_forms[5]
EOF
}

sub _getFeaturePresentActiveParticiple {
    my ($self) = @_;

    my @raw_forms = map { $self->__unfold ($_) } $self->present_active_participle;
    
    return <<EOF;
$raw_forms[0] | $raw_forms[1] | $raw_forms[2]
$raw_forms[3] | $raw_forms[4]
$raw_forms[5] | $raw_forms[6]
$raw_forms[7] | $raw_forms[8]
EOF
}

sub _getFeaturePastActiveAoristParticiple {
    my ($self) = @_;

    my @raw_forms = map { $self->__unfold ($_) } $self->past_active_aorist_participle;
    
    return <<EOF;
$raw_forms[0] | $raw_forms[1] | $raw_forms[2]
$raw_forms[3] | $raw_forms[4]
$raw_forms[5] | $raw_forms[6]
$raw_forms[7] | $raw_forms[8]
EOF
}

sub _getFeaturePastActiveImperfectParticiple {
    my ($self) = @_;

    my @raw_forms = map { $self->__unfold ($_) } $self->past_active_imperfect_participle;
    
    return <<EOF;
$raw_forms[0] | $raw_forms[1] | $raw_forms[2]
$raw_forms[3] | $raw_forms[4]
$raw_forms[5] | $raw_forms[6]
$raw_forms[7] | $raw_forms[8]
EOF
}

sub _getFeaturePastPassiveParticiple {
    my ($self) = @_;

    my @raw_forms = map { $self->__unfold ($_) } $self->past_passive_participle;
    
    return <<EOF;
$raw_forms[0] | $raw_forms[1] | $raw_forms[2]
$raw_forms[3] | $raw_forms[4]
$raw_forms[5] | $raw_forms[6]
$raw_forms[7] | $raw_forms[8]
EOF
}

sub _getFeatureVerbalNoun {
    my ($self) = @_;

    my @raw_forms = map { $self->__unfold ($_) } $self->verbal_noun;
    
    return <<EOF;
$raw_forms[0] | $raw_forms[1]
$raw_forms[2] | $raw_forms[3]
EOF
}

sub _getFeatureImperative {
    my ($self) = @_;

    my @raw_forms = map { $self->__unfold ($_) } $self->imperative;
    
    return <<EOF;
$raw_forms[0] | $raw_forms[1]
EOF
}

sub _getFeatureAdverbialParticiple {
    my ($self) = @_;

    my @raw_forms = map { $self->__unfold ($_) } $self->adverbial_participle;
    
    return <<EOF;
$raw_forms[0]
EOF
}

sub present {
    my ($self) = @_;

    my $stresses = $self->{_present_stresses} || $self->{_stresses};
   
    my $stem1 = $self->{_present_stem1} || $self->{_stem};
    my $stem2 = $self->{_present_stem2} || $self->{_stem};

    return ($self->_emphasize ($self->{_word}),
	    $self->_emphasize ($stem1 . 'ш'),
	    $self->_emphasize ($stem1),
	    $self->_emphasize ($stem1 . 'м'),
	    $self->_emphasize ($stem1 . 'те'),
	    $self->_emphasize ($stem2 . 'т'));
}

sub past_aorist {
    my ($self) = @_;

    my $stresses = $self->{_aorist_stresses} || $self->{_stresses};

    my $stem1 = $self->{_aorist_stem1} || 
	$self->{_present_stem1} || 
	$self->{_stem};
    my $stem2 = $self->{_aorist_stem2} || 
	$self->{_present_stem2} || 
	$self->{_stem};

    return ($self->_emphasize ($stem2 . 'х', @$stresses),
	    $self->_emphasize ($stem1, @$stresses),
	    $self->_emphasize ($stem1, @$stresses),
	    $self->_emphasize ($stem2 . 'хме', @$stresses),
	    $self->_emphasize ($stem2 . 'хте', @$stresses),
	    $self->_emphasize ($stem2 . 'ха', @$stresses));
}

sub past_imperfect {
    my ($self) = @_;

    my $stem1 = $self->{_imperfect_stem1} || 
	$self->{_present_stem1} || 
	$self->{_stem};
    my $stem2 = $self->{_imperfect_stem2} || 
	$self->{_present_stem2} || 
	$self->{_stem};

    return ($self->_emphasize ($stem2 . 'х'),
	    $self->_emphasize ($stem1 . 'ше'),
	    $self->_emphasize ($stem1 . 'ше'),
	    $self->_emphasize ($stem2 . 'хме'),
	    $self->_emphasize ($stem2 . 'хте'),
	    $self->_emphasize ($stem2 . 'ха'));
}

sub imperative {
    my ($self) = @_;

    my $stresses1 = $self->{_stresses};
    my $stresses2 = $self->{_stresses};

    my $stem = $self->{_imperative_stem} || $self->{_word};
    $stem =~ s/.$//;

    my $sg_end = 'й';
    my $pl_end = 'йте';

    if ($stem !~ /[аеиоуъюя]$/) {
	$sg_end = 'и';
	$pl_end = 'ете';
	my @copy1 = @$stresses1;
	$copy1[-1] = -1 if $copy1[-1];
	$stresses1 = \@copy1;
	my @copy2 = @$stresses1;
	$copy2[-1] = -2 if $copy2[-1];
	$stresses2 = \@copy2;
    }

    return ($self->_emphasize ($stem . $sg_end, @$stresses1),
	    $self->_emphasize ($stem . $pl_end, @$stresses2));
}

sub past_active_aorist_participle {
    my ($self) = @_;

    my $stresses = $self->{_perfect_stresses} || $self->{_stresses};

    my $stem1 = $self->{_perfect_stem1};
    unless (defined $stem1) {
	$stem1 = $self->{_aorist_stem1} || 
	    $self->{_present_stem1} || 
	    $self->{_stem};
	$stem1 =~ s/аеиоуюя$//;
    }
    my $stem2 = $self->{_perfect_stem2} || $stem1;
    my $stem3 = $self->{_perfect_stem3};
    unless (defined $stem3) {
	$stem3 = $stem1;
	$stem3 =~ s/ъ$//;
    }

    my $stem4 = $self->{_perfect_stem4} || $stem2;

    return ($self->_emphasize ($stem1 . 'л', @$stresses),
	    $self->_emphasize ($stem3 . 'лия', @$stresses),
	    $self->_emphasize ($stem3 . 'лият', @$stresses),
	    $self->_emphasize ($stem2 . 'ла', @$stresses),
	    $self->_emphasize ($stem2 . 'лата', @$stresses),
	    $self->_emphasize ($stem2 . 'ло', @$stresses),
	    $self->_emphasize ($stem2 . 'лото', @$stresses),
	    $self->_emphasize ($stem4 . 'ли', @$stresses),
	    $self->_emphasize ($stem4 . 'лите', @$stresses));
}

sub past_active_imperfect_participle {
    my ($self) = @_;

    my @imperfect = $self->past_imperfect;

    my $stem1 = $imperfect[0];
    $stem1 =~ s/х$//;
    my $stem2 = $stem1;
    my $stem3 = $imperfect[1];
    $stem3 =~ s/ше$//;

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

    return ($stem1 . 'л',
	    $stem2 . 'лия',
	    $stem2 . 'лият',
	    $stem2 . 'ла',
	    $stem2 . 'лата',
	    $stem2 . 'ло',
	    $stem2 . 'лото',
	    $stem3 . 'ли',
	    $stem3 . 'лите');
}

sub past_passive_participle {
    my ($self) = @_;

    my @aorist = $self->past_aorist;

    my $stem1 = $aorist[1];
    $stem1 =~ s/[^\x00-\xff]((?:[\x00-\xff])*)$/е$1/ 
	if ($self->isa ('BGTrainer::Word::Verb::II_173')
	    && !($self->isa ('BGTrainer::Word::Verb::II_177')
		 || $self->isa ('BGTrainer::Word::Verb::II_181')
		 || $self->isa ('BGTrainer::Word::Verb::II_183')
		 || $self->isa ('BGTrainer::Word::Verb::II_185')
		 ));

    my $stem2 = $stem1;
    
    my $stem3 = $stem1;
    $stem3 =~ s/[^\x00-\xff]((?:[\x00-\xff])*)$/е$1/
	if (!($self->isa ('BGTrainer::Word::Verb::I_151')
	      || $self->isa ('BGTrainer::Word::Verb::I_154')
	      || $self->isa ('BGTrainer::Word::Verb::I_155')
	      || $self->isa ('BGTrainer::Word::Verb::I_160_a')
	      || $self->isa ('BGTrainer::Word::Verb::I_161')
	      || $self->isa ('BGTrainer::Word::Verb::I_167')
	      || $self->isa ('BGTrainer::Word::Verb::II_179')
	      || $self->isa ('BGTrainer::Word::Verb::II_183')
	      || $self->isa ('BGTrainer::Word::Verb::II_185')
	      ));

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

    return ($stem1 . 'н',
	    $stem2 . 'ния',
	    $stem2 . 'ният',
	    $stem2 . 'на',
	    $stem2 . 'ната',
	    $stem2 . 'но',
	    $stem2 . 'ното',
	    $stem3 . 'ни',
	    $stem3 . 'ните');
}

sub present_active_participle {
    my ($self) = @_;

    my @imperfect = $self->past_imperfect;

    my $stem1 = $imperfect[0];
    $stem1 =~ s/х$//;
    my $stem2 = $stem1;

    if (1 == bg_count_syllables $stem2) {
	$stem2 .= 'ю';
	$stem2 = $self->_emphasize ($stem2, 1);
	chop $stem2;
    }

    return ($stem1 . 'щ',
	    $stem2 . 'щия',
	    $stem2 . 'щият',
	    $stem2 . 'ща',
	    $stem2 . 'щата',
	    $stem2 . 'що',
	    $stem2 . 'щото',
	    $stem2 . 'щи',
	    $stem2 . 'щите');
}

sub adverbial_participle {
    my ($self) = @_;

    my $stresses = $self->{_stresses};

    my $stem = $self->{_gerund_stem} or return undef;;

    return ($self->_emphasize ($stem . 'йки', @$stresses));
}

sub future {
    my ($self) = @_;

    return map {
	defined $_ ? 'ще ' . $_ : undef;
    } $self->present;
}

sub present_perfect {
    my ($self) = @_;

    my @p = $self->past_active_aorist_participle;

    return (defined $p[0] ? $p[0] . ' съм' : undef,
	    defined $p[0] ? $p[0] . ' си' : undef,
	    defined $p[0] ? $p[0] . ' е' : undef,
	    defined $p[7] ? $p[7] . ' сме' : undef,
	    defined $p[7] ? $p[7] . ' сте' : undef,
	    defined $p[7] ? $p[7] . ' са' : undef);
}

sub past_perfect {
    my ($self) = @_;

    my @p = $self->past_active_aorist_participle;

    my $beshe = $self->_aux_beshe;
    my $bqhme = $self->_aux_bqhme;
    my $bqhte = $self->_aux_bqhte;
    my $bqha = $self->_aux_bqha;

    return (defined $p[0] ? 'бях ' . $p[0] : undef,
	    defined $p[0] ? $beshe . ' ' . $p[0] : undef,
	    defined $p[0] ? $beshe . ' ' . $p[0] : undef,
	    defined $p[7] ? $bqhme . ' ' . $p[7] : undef,
	    defined $p[7] ? $bqhte . ' ' . $p[7] : undef,
	    defined $p[7] ? $bqha . ' ' . $p[7] : undef);
}

sub future_perfect {
    my ($self) = @_;

    my @p = $self->past_active_aorist_participle;

    return (defined $p[0] ? 'ще съм ' . $p[0] : undef,
	    defined $p[0] ? 'ще си ' . $p[0] : undef,
	    defined $p[0] ? 'ще е ' . $p[0] : undef,
	    defined $p[7] ? 'ще сме ' . $p[7] : undef,
	    defined $p[7] ? 'ще сте ' . $p[7] : undef,
	    defined $p[7] ? 'ще са ' . $p[7] : undef);
}

sub past_future {
    my ($self) = @_;

    my @p = $self->present;

    my $shteshe = $self->_aux_shteshe;
    my $shtqhme = $self->_aux_shtqhme;
    my $shtqhte = $self->_aux_shtqhte;
    my $shtqha = $self->_aux_shtqha;

    return (defined $p[0] ? 'щях да ' . $p[0] : undef,
	    defined $p[1] ? $shteshe . ' да ' . $p[1] : undef,
	    defined $p[2] ? $shteshe . ' да ' . $p[2] : undef,
	    defined $p[3] ? $shtqhme . ' да ' . $p[3] : undef,
	    defined $p[4] ? $shtqhte . ' да ' . $p[4] : undef,
	    defined $p[5] ? $shtqha . ' да ' . $p[5] : undef);
}

sub past_future_perfect {
    my ($self) = @_;

    my @p = $self->past_active_aorist_participle;

    my $shteshe = $self->_aux_shteshe;
    my $shtqhme = $self->_aux_shtqhme;
    my $shtqhte = $self->_aux_shtqhte;
    my $shtqha = $self->_aux_shtqha;

    return (defined $p[0] ? 'щях да съм ' . $p[0] : undef,
	    defined $p[0] ? $shteshe . ' да си ' . $p[0] : undef,
	    defined $p[0] ? $shteshe . ' да е ' . $p[0] : undef,
	    defined $p[7] ? $shtqhme . ' да сме ' . $p[7] : undef,
	    defined $p[7] ? $shtqhte . ' да сте ' . $p[7] : undef,
	    defined $p[7] ? $shtqha . ' да са ' . $p[7] : undef);
}

sub conditional {
    my ($self) = @_;

    my @p = $self->past_active_aorist_participle;

    my $bihme = $self->_aux_bihme;
    my $bihte = $self->_aux_bihte;
    my $biha = $self->_aux_biha;

    return (defined $p[0] ? 'бих ' . $p[0] : undef,
	    defined $p[0] ? 'би ' . $p[0] : undef,
	    defined $p[0] ? 'би ' . $p[0] : undef,
	    defined $p[7] ? $bihme . ' ' . $p[7] : undef,
	    defined $p[7] ? $bihte . ' ' . $p[7] : undef,
	    defined $p[7] ? $biha . ' ' . $p[7] : undef);
}

sub present_renarrative {
    my ($self) = @_;

    my @p = $self->past_active_imperfect_participle;

    return (defined $p[0] ? $p[0] . ' съм' : undef,
	    defined $p[0] ? $p[0] . ' си' : undef,
	    defined $p[0] ? $p[0] : undef,
	    defined $p[7] ? $p[7] . ' сме' : undef,
	    defined $p[7] ? $p[7] . ' сте': undef,
	    defined $p[7] ? $p[7] : undef);
}

sub past_imperfect_renarrative {
    shift->present_renarrative;
}

sub past_aorist_renarrative {
    my ($self) = @_;

    my @p = $self->past_active_aorist_participle;

    my $bili = $self->_aux_bili;

    return (defined $p[0] ? $p[0] . ' съм' : undef,
	    defined $p[0] ? $p[0] . ' си' : undef,
	    defined $p[0] ? $p[0] : undef,
	    defined $p[7] ? $p[7] . ' сме' : undef,
	    defined $p[7] ? $p[7] . ' сте' : undef,
	    defined $p[7] ? $p[7] : undef);
}

sub present_perfect_renarrative {
    my ($self) = @_;

    my @p = $self->past_active_aorist_participle;

    my $bili = $self->_aux_bili;

    return (defined $p[0] ? 'бил съм ' . $p[0] : undef,
	    defined $p[0] ? 'бил си ' . $p[0] : undef,
	    defined $p[0] ? 'бил ' . $p[0] : undef,
	    defined $p[7] ? $bili . ' сме ' . $p[7] : undef,
	    defined $p[7] ? $bili . ' сте ' . $p[7] : undef,
	    defined $p[7] ? $bili . ' ' . $p[7] : undef);
}

sub past_perfect_renarrative {
    shift->present_perfect_renarrative;
}

sub future_renarrative {
    my ($self) = @_;

    my @p = $self->present;

    my $shteli = $self->_aux_shteli;

    return (defined $p[0] ? 'щял съм да ' . $p[0] : undef,
	    defined $p[1] ? 'щял си да ' . $p[1] : undef,
	    defined $p[2] ? 'щял да ' . $p[2] : undef,
	    defined $p[3] ? $shteli . ' сме да ' . $p[3] : undef,
	    defined $p[4] ? $shteli . ' сте да ' . $p[4] : undef,
	    defined $p[5] ? $shteli . ' да ' . $p[5] : undef);
}

sub past_future_renarrative {
    shift->future_renarrative;
}

sub future_perfect_renarrative {
    my ($self) = @_;

    my @p = $self->past_active_aorist_participle;

    my $shteli = $self->_aux_shteli;

    return (defined $p[0] ? 'щял съм да съм ' . $p[0] : undef,
	    defined $p[0] ? 'щял си да си ' . $p[0] : undef,
	    defined $p[0] ? 'щял да е ' . $p[0] : undef,
	    defined $p[7] ? $shteli . ' сме да сме ' . $p[7] : undef,
	    defined $p[7] ? $shteli . ' сте да сте ' . $p[7] : undef,
	    defined $p[7] ? $shteli . ' да са ' . $p[7] : undef);
}

sub past_future_perfect_renarrative {
    shift->future_perfect_renarrative;
}

sub reflexive_passive {
    my ($self) = @_;

    return map {
	defined $_ ? $_ . ' се' : undef;
    } $self->present;
}

sub renarrative_passive {
    my ($self) = @_;

    my @participles = $self->past_passive_participle;

    my $stem1 = $participles[0];
    my $stem2 = $participles[0];
    my $stem3 = $participles[7];

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

    return ($stem1 . ' съм',
	    $stem1 . ' си',
	    $stem1 . ' е',
	    $stem2 . 'а е',
	    $stem2 . 'о е',
	    $stem3 . ' сме',
	    $stem3 . ' сте',
	    $stem3 . ' са');
}

sub verbal_noun {
    my ($self) = @_;

    my @participles = $self->past_passive_participle;

    my $stem = $participles[0];

    if (1 == bg_count_syllables $stem) {
	$stem .= 'ю';
	$stem = $self->_emphasize ($stem, 1);
	chop $stem;
    }

    return ($stem . 'е',
	    $stem . 'ето',
	    $stem . 'ия',
	    $stem . 'ията');
}

sub _aux_beshe {
    my ($self) = @_;

    return $self->_emphasize ('беше', 1);
}

sub _aux_bqhme {
    my ($self) = @_;

    return $self->_emphasize ('бяхме', 1);
}

sub _aux_bqhte {
    my ($self) = @_;

    return $self->_emphasize ('бяхте', 1);
}

sub _aux_bqha {
    my ($self) = @_;

    return $self->_emphasize ('бяха', 1);
}

sub _aux_shteshe {
    my ($self) = @_;

    return $self->_emphasize ('щеше', 1);
}

sub _aux_shtqhme {
    my ($self) = @_;

    return $self->_emphasize ('щяхме', 1);
}

sub _aux_shtqhte {
    my ($self) = @_;

    return $self->_emphasize ('щяхте', 1);
}

sub _aux_shteli {
    my ($self) = @_;

    return $self->_emphasize ('щели', 1);
}

sub _aux_shtqha {
    my ($self) = @_;

    return $self->_emphasize ('щяха', 1);
}

sub _aux_bihme {
    my ($self) = @_;

    return $self->_emphasize ('бихме', 1);
}

sub _aux_bihte {
    my ($self) = @_;

    return $self->_emphasize ('бихте', 1);
}

sub _aux_biha {
    my ($self) = @_;

    return $self->_emphasize ('биха', 1);
}

sub _aux_bili {
    my ($self) = @_;

    return $self->_emphasize ('били', 1);
}

sub _pronoun_nie {
    my ($self) = @_;

    return $self->_emphasize ('ние', 1);
}

sub _pronoun_vie {
    my ($self) = @_;

    return $self->_emphasize ('вие', 1);
}

sub __unfold {
    my ($self, $maybe_ref) = @_;

    if (ref $maybe_ref) {
	return join '/', @$maybe_ref;
    } else {
	return $maybe_ref;
    }
}

sub describeVariations {
    my @variations = (
                  {
                      name => __"Reflexive",
                      id => 'refl',
                      type => 'select',
                      values => [
				 [refl => __"reflexive"],
				 [irrefl => __"irreflexive"],
				 ],
			  default => 'irreflexive',
		      },
                  {
                      name => __"Aspect",
                      id => 'aspect',
                      type => 'select',
                      multiple => 1,
                      values => [
                                 [pf => __"perfective"],
                                 [impf => __"imperfective"],
				 ],
			  default => 'imperfective',
		      },
                  {
                      name => __"Transitive",
                      id => 'transitive',
                      type => 'select',
                      multiple => 1,
                      values => [
                                 [trans => __"transitive"],
                                 [intrans => __"intransitive"],
				 ],
			  default => 'transitive',
                  },
                      );

    return \@variations;
}

sub longTable {
    return 1;
}

sub describeWord {
    my ($self) = @_;

    my @description;

    my $additional = $self->{_additional};

    if ($additional->{impf} && $additional->{pf}) {
	push @description, '(не)свършен';
    } elsif ($additional->{impf}) {
	push @description, 'несвършен';
    } elsif ($additional->{pf}) {
	push @description, 'свършен';
    }

    if ($additional->{intrans} && $additional->{trans}) {
	push @description, '(не)преходен';
    } elsif ($additional->{intrans}) {
	push @description, 'непреходен';
    } elsif ($additional->{trans}) {
	push @description, 'преходен';
    }

    return join ' ', @description;
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
