package BGTrainer::Controller::BaseForm;

use strict;
use utf8;
use warnings;
use base 'Catalyst::Controller';
use Locale::TextDomain qw (net.guido-flohr.bgtrainer);
use BGTrainer::Util qw (bg_word escape_html split_pg_array clean_params
			bg_count_syllables bg_emphasize join_pg_array
			sendmail bg_standout);
use BGTrainer::Case qw (bg_tolower);
use IWL;
use IWL::Config qw (%IWLConfig);
use Locale::Messages qw (turn_utf_8_on);
use Roman qw (isroman);

=head1 NAME

BGTrainer::Controller::BaseForm - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index : Private {
    my ($self, $c) = @_;

    $c->response->body('Matched BGTrainer::Controller::BaseForm in BaseForm.');
}

sub display : Local {
    my ($self, $c, $id, $inflection_id) = @_;
    
    unless ($id =~ /^[0-9]+$/) {
	die __"Invalid id!";
    }

    unless (defined $inflection_id && $inflection_id =~ /^[0-9]+$/) {
	$inflection_id = 0;
    }

    my $lingua = 'en';
    if ($c->user) {
	$lingua = $c->user->lingua || 'en';
    }
    $lingua =~ s/-.*//;
    
    my $result = $c->model('BGTrainerDB::BaseForm')->find ($id, {
	columns => [qw (id word frequency inflections emphasis additional 
			peer)],
	# The column name has to be unique ...
	include_columns => ['category.name'],
	join => qw /category/,
    });

    unless ($result) {
	$c->stash->{error_msg} = __"No such word!";
	$c->stash->{template} = 'word/search.tt2';
	return 1;
    }

    $c->stash->{baseform} = $result;

    my $frequency = $result->frequency;
    my $lower = $c->model('BGTrainerDB::BaseForm')->search 
	(
	 { frequency => { '<' => $frequency }},
	 )->count;
    my $higher = $c->model('BGTrainerDB::BaseForm')->search 
	(
	 { frequency => { '>' => $frequency }},
	 )->count;
    my $same = $c->model('BGTrainerDB::BaseForm')->search 
	(
	 { frequency => { '=' => $frequency }},
	 )->count;
    --$same;
    $lower += $same / 2;
    $higher += $same / 2;
    my $total = $lower + $higher;
    $lower = 100 * $lower / $total;
    $higher = 100 * $higher / $total;
    my $color = sprintf "%02x0000", 256 * $lower / 100;
    $c->stash->{lower} = $lower;
    $c->stash->{higher} = $higher;
    $c->stash->{color} = $color;
    $c->stash->{frequency} = sprintf "%.02f", $lower;
    # Avoid retrieving category name again from template.
    my $word_type = $result->get_column ('name');
    $c->stash->{category} = $word_type;
    $c->stash->{template} = 'baseform/display.tt2';
    
    my $class_name = 'BGTrainer::Word::' . $word_type;

    my @inflections = split_pg_array $result->inflections;
    my $inflection = $inflections[$inflection_id];

    unless ($inflection) {
	$inflection_id = 0;
	$inflection = $inflections[0];
    }

    $class_name .= '::' . $inflection 
	if defined $inflection && length $inflection;
    eval "require $class_name;";

    if ($@) {
	$c->stash->{error_msg} = __x("Error creating word class '{name}': "
				     . "{error}.\n",
				     name => $class_name,
				     error => escape_html $@);
	return 1;
    }

    if (@inflections > 1) {
	my @alternate_inflections;
	my $num_inflections = @inflections;

	foreach my $i (0 .. $num_inflections) {
	    push @alternate_inflections, {
		id => $i,
		name => $inflections[$i],
	    };
	}
	$c->stash->{inflections} = \@alternate_inflections;
	$c->stash->{num_inflections} = $num_inflections;
	$c->stash->{inflection} = $inflection_id;
    }

    my @stresses = split_pg_array $result->emphasis;

    my @additional = split_pg_array $result->additional;

    my $word_obj = $class_name->new ($result->word,
				     stresses => \@stresses,
				     additional => \@additional);
    $word_obj->setEmphasizer (sub { '<u>' . $_[0] . '</u>' });

    if ($result->peer) {
	my $peer_id = $result->peer;
	my $peer = $c->model('BGTrainerDB::BaseForm')->find ($peer_id)->word;
	my $link = $c->uri_for('/baseform/display') . '/' . $peer_id;
	$c->stash->{additional} = qq{ -&gt; <a href="$link">$peer</a>};
    }

    $c->stash->{word_obj} = $word_obj;

    my @hits = $c->model("BGTrainerDB::Translation_\U$lingua")->search ({
	base_id => $id,
    });

    if (@hits) {
	my $list = IWL::List->new (type => 'ordered');

	foreach my $hit (sort { 
	    $a->translation_id <=> $b->translation_id
	    } @hits) {

	    my $translation = bg_standout (escape_html ($hit->translation),
					   sub { '<b>' . $_[0] . '</b>' });
	    my $idx = $hit->translation_id;

	    my @comments = map {
		escape_html $_;
	    } grep {
		defined $_ && length $_;
	    } split_pg_array $hit->comment;
	    
	    my $item = IWL::Label->new;
	    $list->appendListItem ($item);

	    foreach my $comment (@comments) {
		$item->appendTextType ($comment, 'em');
	    }

	    $item->appendText ($translation);
	}
	$c->stash->{translation} = $list->getContent;
    }

    return 1;
}

# FIXME: This has to be split up into smaller functions.
sub __createForm : Private {
    my ($self, $c, $id) = @_;

    my $params = IWL::Stash->new ($c->request->params);

    my %word_args;
    if ($id) {
	$params->setValues (id => $id);
	
	my $result = $c->model('BGTrainerDB::BaseForm')->find ($id, {
	    columns => [qw (word category inflections emphasis additional)],
	});
	
	unless ($result) {
	    $c->stash->{error_msg} = __"No such word!";
	    $c->stash->{template} = 'baseform/edit.tt2';
	    return 1;
	}
	
	$params->setValues (word => $result->word);
	my $category = $result->get_column ('category');
	$params->setValues (category => $category);

	my @stresses = split_pg_array $result->emphasis;
	my $num_syllables = bg_count_syllables $result->word;
	foreach (@stresses) {
	    $_ = $num_syllables + 1 + $_ if $_ < 0;
	}
	$params->setValues (stresses => @stresses);
	
	my @inflections = split_pg_array $result->inflections;
	$params->setValues (inflections => @inflections);

	%word_args= map { 
	    $_ => 1;
	} grep {
	    defined $_ && length $_;
	} split_pg_array $result->additional;


	my $linguas = $c->config->{linguas};
	foreach my $lingua (keys %$linguas) {
	    $lingua =~ s/-.*//;
	    my @hits = $c->model("BGTrainerDB::Translation_\U$lingua")->search ({
		base_id => $id,
	    });
	    foreach my $hit (sort { 
		$a->translation_id <=> $b->translation_id
		} @hits) {
		$params->pushValues ("translation_$lingua",
				     $hit->translation);
		my $idx = $hit->translation_id;
		my @comments = grep {
		    defined $_ && length $_;
		} split_pg_array $hit->comment;
		$params->pushValues ("comment_${lingua}_$idx", @comments);
	    }
	}
    }

    $id = $params->getValues ('id') unless defined $id;
    clean_params $params, 1;

    # This will also turn a 0 into the empty string, who cares.
    my $word = $params->getValues ('word');
    $word = '' unless $word;

    if ($word && !bg_word $word) {
	$c->stash->{error_msg} = __x("Word '{word}' contains "
				    . "non-Bulgarian characters!",
				     word => $params->{word});
	$word = '';
    }

    # Order ...
    my @categories = $c->model('BGTrainerDB::Category')->all;
    my %long_categories = map { $_->id => $_->long_name } @categories;
    my %categories = map { $_->id => $_->name } @categories;

    my $num_categories = @categories;

    my $cat_num = $params->getValues ('category');
    if ($cat_num < 1 || $cat_num > $num_categories) {
	$cat_num = 0;
	$params->deleteValues ('category');
    }

    my $form = IWL::Form->new (action => '/baseform/save', 
			       method => 'post',
			       name => 'edit_word');

    my @rows;

    my $table = IWL::Table->new (cellspacing => 1,
				 cellpadding => 2);
    $form->appendChild ($table);

    # The word, either as an input or as an unchangable text.
    push @rows, IWL::Table::Row->new;
    my $row = $rows[-1];
    $row->appendTextCell (__"Word");

    my @stresses = $params->getValues ('stresses');
    if ($word) {
	my $cb = sub { '<u>' . $_[0] . '</u>' };
	my $pretty_word = bg_emphasize $word, $cb, @stresses;

	$row->appendTextCell ($pretty_word);

	$form->appendChild (IWL::Hidden->new (name => 'word',
					      value => $word));
    } else {
	$row->appendCell (IWL::Input->new (name => 'word',
					   value => ''));
    }

    # The select box for the type.
    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell ('Type');

    if ($cat_num) {
	$form->appendChild (IWL::Hidden->new (name => 'category',
					      values => $cat_num));
	__($row->appendTextCell ($long_categories{$cat_num}));
    } else {
	my $category_combo = IWL::Combo->new (name => 'category');
	$row->appendCell ($category_combo);
	$category_combo->appendOption (__"Please select a word type!", 0, 1);
	foreach my $record (@categories) {
	    my $value = $record->id;
	    my $name = __($record->long_name);
	    $category_combo->appendOption ($name, $value);
	}
    }

    my $num_syllables = bg_count_syllables $word;
    if ($num_syllables > 1) {
	push @rows, IWL::Table::Row->new;

	$row = $rows[-1];
	$row->appendTextCell (__"Stress(es) on syllable #");

	my $stress_combo = IWL::Combo->new (name => 'stresses',
					    multiple => 'multiple');
	$row->appendCell ($stress_combo);

	$stress_combo->appendOption (1, 1, 1);

	foreach my $syllable (1 .. $num_syllables - 1) {
	    $stress_combo->appendOption ($syllable + 1, $syllable + 1);
	}
    } else {
	$form->appendChild (IWL::Hidden->new (name => 'stresses',
					      values => 1));
	$params->setValues (stresses => 1);
    }

    my $linguas = $c->config->{linguas};
    foreach my $lingua (sort keys %$linguas) {
	push @rows, IWL::Table::Row->new;
	$row = $rows[-1];
	$row->appendCell (IWL::Label->new
			  ->appendText ("<h2>$linguas->{$lingua}</h2>"));
	$row->{childNodes}->[-1]->setAttribute (colspan => 2);

	push @rows, IWL::Table::Row->new;
	$row = $rows[-1];
	$lingua =~ s/-.*//;
	$row->appendCell ($self->__translationForm ($c, $lingua, $params));
	$row->{childNodes}->[-1]->setAttribute (colspan => 2);
    }

    if ($cat_num) {
	my $enough_info = 1;
	my $type = $categories{$cat_num};

	my $class_name = "BGTrainer::Word::$type";
	eval "require $class_name";
	die $@ if $@;

	my @subtypes = $class_name->getSubTypes;

	if (@subtypes) {
	    push @rows, IWL::Table::Row->new;
	    $row = $rows[-1];
	    
	    $row->appendTextCell (__"Subtype");
	    my $subtype_combo = IWL::Combo->new (name => 'inflections',
						 multiple => 'multiple',
						 size => 5);
	    $row->appendCell ($subtype_combo);
	    
	    foreach my $subtype (@subtypes) {
		$subtype_combo->appendOption ($subtype, $subtype);
	    }

	    my %all_subtypes = map { $_ => 1 } @subtypes;

	    my @selected_subtypes = $params->getValues ('inflections');
	    foreach (@selected_subtypes) {
		# Probably the main type changed.
		unless ($all_subtypes{$_}) {
		    @selected_subtypes = ($subtypes[0]);
		}
	    }
	    my $subtype = $selected_subtypes[0];
	    undef $enough_info unless $subtype;

	    $class_name .= '::' . $subtype if $subtype;
	    eval "require $class_name";

	    die $@ if $@;
	}

	foreach my $key ($params->keys) {
	    next unless $key =~ /^var_(.*)/;
	    
	    my $arg = $1;
	    my @values = $params->getValues ($key);
	    foreach my $value (@values) {
		$word_args{$value} = 1;
	    }
	}

	if ($enough_info) {
	    my $word_obj = $class_name->new ($word, 
					     stresses => \@stresses,
					     %word_args);
	    $c->stash->{word_obj} = $word_obj;
	    $word_obj->setEmphasizer (sub { '<u>' . $_[0] . '</u>' });

	    foreach my $record (@{$word_obj->describeVariations}) {
		push @rows, IWL::Table::Row->new;
		$row = $rows[-1];
		
		$row->appendTextCell ($record->{name});
		
		my $var_type = $record->{type};
		my $var_id = $record->{id};
		my $multiple = $record->{multiple};

		my $combo = IWL::Combo->new (name => 'var_' . $var_id,
					     multiple => $multiple);
		$row->appendCell ($combo);
		if ('boolean' eq $var_type) {
		    $combo->appendOption (__"no", '');
		    $combo->appendOption (__"yes", $var_id, 1);
		    if ($word_args{$var_id}) {
			$params->setValues ('var_' . $var_id, $var_id);
		    } else {
			$params->setValues ('var_' . $var_id, '');
		    }
		} elsif ('select' eq $var_type) {
		    my $count = 0;
		    foreach (@{$record->{values}}) {
			my ($value, $text) = @$_;
			if ($word_args{$value}) {
			    $params->pushValues ('var_' . $var_id, $value);
			}
			$combo->appendOption ($text, $value, !$count++);
		    }
		}
	    }
	}
    }

    foreach my $row (@rows) {
	$table->appendBody ($row);
    }

    if ($cat_num) {
	$form->appendChild (IWL::Hidden->new (name => 'last_category',
					      value => $cat_num));
	$params->setValues (last_category => $cat_num);
    }

    if ($id) {
	$form->appendChild (IWL::Hidden->new (name => 'id',
					      value => $id));
	$params->setValues (id => $id);
    }

    my $skin_js = IWL::Script->new;
    $form->appendChild ($skin_js);

    my $skin_dir = $IWLConfig{SKIN_DIR};

    $skin_js->appendScript ("var skin_dir = '$skin_dir'\n");

    my $submit = IWL::Input->new (name => 'save', type => 'submit',
				  value => __"Save");
    $form->appendChild ($submit);

    my $lingua = 'en';
    if ($c->user) {
	$lingua = $c->user->lingua || 'en';
    }
    $lingua =~ s/-.*//;

    my @translations = $params->getValues ("translation_$lingua");
    if (@translations) {
	my $list = IWL::List->new (type => 'ordered');

	my $idx = 0;
	foreach my $translation (@translations) {
	    $translation = bg_standout (escape_html ($translation),
					sub { '<b>' . $_[0] . '</b>' });
	    my @comments = $params->getValues ("comment_${lingua}_${idx}");
	    ++$idx;

	    my $item = IWL::Label->new;
	    $list->appendListItem ($item);

	    foreach my $comment (@comments) {
		$item->appendTextType ($comment, 'em');
	    }

	    $item->appendText ($translation);
	}
	$c->stash->{translation} = $list->getContent;
    }

    $form->applyState ($params);

    return $form->getContent;
}

sub __translationForm {
    my ($self, $c, $lingua, $params) = @_;

    my $container = IWL::Container->new;

    $lingua =~ s/-.*//;
    
    my @translations = $params->getValues ("translation_$lingua");

    foreach my $key ($params->keys) {
	next if $key !~ /^(up|down|minus|plus)_${lingua}_([0-9]+)$/;

	my ($cmd, $idx) = ($1, $2);

	if ('up' eq $cmd) {
	    last if $idx < 1;
	    last if $idx > $#translations;
	    @translations[$idx, $idx - 1] = @translations[$idx - 1, $idx];
	} elsif ('down' eq $cmd) {
	    last if $idx >= $#translations;
	    @translations[$idx, $idx + 1] = @translations[$idx + 1, $idx];
	} elsif ('minus' eq $cmd) {
	    last if $idx > $#translations;
	    splice @translations, $idx, 1;
	} elsif ('plus' eq $cmd) {
	    last if $idx > $#translations;
	    splice @translations, $idx, 0, ''; 
	}

	last;
    } 

    @translations = ('') unless @translations;

    my $dict_comments = $c->config->{dict_comments};

    for (my $idx = 0; $idx < @translations; ++$idx) {
	my $vbox = IWL::Container->new;
	$container->appendChild ($vbox);
	
	my $hbox = IWL::HBox->new;
	$vbox->appendChild ($hbox);

	unless ($idx == 0) {
	    $hbox->appendChild (IWL::Input->new (name => "up_${lingua}_$idx",
						 type => 'submit',
						 value => "\x{21d1}"));
	}
	unless ($idx == $#translations) {
	    $hbox->appendChild (IWL::Input->new (name => "down_${lingua}_$idx",
						 type => 'submit',
						 value => "\x{21d3}"));
	}
	unless (1 == @translations) {
	    $hbox->appendChild (IWL::Input->new (name => "minus_${lingua}_$idx",
						 type => 'submit',
						 value => "-"));
	}
	$hbox->appendChild (IWL::Input->new (name => "plus_${lingua}_$idx",
					     type => 'submit',
					     value => "+"));

	$hbox = IWL::HBox->new;
	$vbox->appendChild ($hbox);

	my $comments = IWL::Combo->new (name => "comment_${lingua}_$idx",
					multiple => 'multiple',
					size => 3);
	foreach my $dict_comment (@$dict_comments) {
	    $comments->appendOption ($dict_comment, $dict_comment);
	}
	$hbox->appendChild ($comments);

	my $text = IWL::Textarea->new (name => "translation_${lingua}",
				       cols => 65,
				       rows => 3,
				       style => { float => 'none' });
	$hbox->appendChild ($text);
    }

    return $container;
}

sub edit : Local {
    my ($self, $c, $id) = @_;

    $c->stash->{form} = $self->__createForm ($c, $id);
    $c->stash->{template} = 'baseform/edit.tt2';

    return 1;
}

sub editpeer : Local {
    my ($self, $c, $id) = @_;

    $c->stash->{form} = $self->__createPeerForm ($c, $id);
    $c->stash->{template} = 'baseform/editpeer.tt2';

    return 1;
}

sub deletepeer : Local {
    my ($self, $c, $id) = @_;

    my $result_set = $c->model('BGTrainerDB::BaseForm');
    my $schema = $result_set->result_source->schema;

    eval {
	$schema->txn_begin;

	my $me = $result_set->find($id);
	my $peer_id = $me->peer;

	$result_set->find($id)->update ({peer => undef});
	$result_set->find($peer_id)->update ({peer => undef});
    };
    if ($@) {
	$c->stash->{error_msg} = $@;
	$schema->txn_rollback;
	$c->detach ('editpeer');
    } else {
	$schema->txn_commit;
    }

    $c->stash->{status_msg} = __"Connection successfully deleted!";

    $c->detach ('display', [$id]);

    return 1;
}

sub savepeer : Local {
    my ($self, $c) = @_;

    my $params = IWL::Stash->new ($c->request->params);
    my $id = $params->getValues ('id');
    unless ($id && $id =~ /^[0-9]+$/) {
	$c->detach ('/word/search');
    }

    my $peer_id = $params->getValues ('peer');
    unless ($peer_id && $peer_id =~ /^[0-9]+$/) {
	$c->detach ('editpeer');
    }

    if ($params->getValues ('do_search')) {
	$c->detach ('editpeer');
    }

    my $me = $c->model('BGTrainerDB::BaseForm')->find ($id, {
	columns => [qw (word category peer additional)],
    });
    
    unless ($me) {
	$c->stash->{error_msg} = __"No such word!";
	$c->detach ('/word/search');
    }
    
    my %my_aspects = map { $_ => 1 } split_pg_array $me->additional;
    unless ($my_aspects{pf} || $my_aspects{impf}) {
	$c->stash->{error_msg} = __"Set aspect of this word first!";
	$c->detach ('display', [$id]);
    }

    my $word = $me->word;
    my $category = $me->get_column ('category');

    my $catname = $me->category->name;
    unless ('Verb' eq $catname) {
	$c->stash->{error_msg} = __"Only verbs can build aspect pairs.";
	$c->detach ('display', [$id]);
	return 1;
    }

    my $old_peer = $me->peer;
    if ($old_peer) {
	$c->stash->{error_msg} = __("You have to delete the existing "
				    . "relationship first.");
	$c->detach ('display', [$id]);
	return 1;
    }

    clean_params $params, 1;

    my $peer =$c->model('BGTrainerDB::Baseform')->find ($peer_id);
    unless ($peer) {
	$c->detach ('display', [$id]);
	return 1;
    }
 
    my %peer_aspects = map { $_ => 1 } split_pg_array $peer->additional;
    my $conflict = $self->__isAspectConflict (\%my_aspects, \%peer_aspects);
    if ($conflict) {
	$c->stash->{error_msg} = $conflict;
	$c->detach ('display', [$id]);
    }
    
    my $result_set = $c->model('BGTrainerDB::BaseForm');
    my $schema = $result_set->result_source->schema;

    eval {
	$schema->txn_begin;
	$result_set->find($id)->update ({peer => $peer_id});
	$result_set->find($peer_id)->update ({peer => $id});
	
	my $linguas = $c->config->{linguas};
	foreach my $lingua (keys %$linguas) {
	    $lingua =~ s/-.*//;
	    
	    $c->model("BGTrainerDB::Translation_\U$lingua")
		->search(base_id => $peer_id)->delete_all;

	    my @trans = $c->model("BGTrainerDB::Translation_\U$lingua")
		->search(base_id => $id);
	    
	    foreach my $trans (@trans) {
		my $translation_id = $trans->translation_id;
		my $comment = $trans->comment;
		my $translation = $trans->translation;
		$c->model("BGTrainerDB::Translation_\U$lingua")
		    ->create ({ base_id => $peer_id,
				translation_id => $translation_id,
				translation => $translation,
				comment => $comment,
			    });
	    }
	}
    };
    if ($@) {
	$c->stash->{error_msg} = $@;
	$schema->txn_rollback;
	$c->detach ('editpeer');
    } else {
	$schema->txn_commit;
    }

    $c->stash->{status_msg} = __"Verbs connected as aspect pair!";
    $c->response->redirect ($c->uri_for ('/baseform/display') . '/' . $id);
    
    return 1;
}

sub save : Local {
    my ($self, $c) = @_;

    my $params = IWL::Stash->new ($c->request->params);

    my $id = $params->getValues ('id');

    my $word = $params->getValues ('word');
    turn_utf_8_on $word;
    $word =~ s/^\s+//;
    $word =~ s/\s+$//;
    $word = bg_tolower $word;
    unless (bg_word ($word)) {
	$c->stash->{error_msg} = __x("Word '{word}' contains non-Bulgarian "
				     . "characters.",
				     word => $word);
	$c->detach ('edit');
    }

    my $category = $params->getValues ('category');
    my $last_category = $params->getValues ('last_category');

    unless ($word && $category
	    && $last_category
	    && $last_category eq $category) {
	$c->detach ('edit');
    }

    foreach my $param ($params->keys) {
	if ($param =~ /^(?:up|down|plus|minus)_/) {
	    $c->detach ('edit');
	}
    }

    my @inflections = $params->getValues ('inflections');
    foreach my $inflection (@inflections) {
	my @parts = split /_/, $inflection;
	foreach my $part (@parts) {
	    next if isroman $part;
	    next if $part =~ /^[0-9]+$/;
	    next if $part =~ /^[a-z]+$/;
	    die "Invalid inflection\n";
	}
    }
    my $inflections = join_pg_array @inflections;

    my @stresses = $params->getValues ('stresses');
    foreach my $stress (@stresses) {
	die "Invalid syllable" unless $stress =~ /^[0-9]+/;
    }
    my $stresses = join_pg_array @stresses;
    
    my @additional;
    foreach my $key ($params->keys) {
	next unless $key =~ /^var_/;
	push @additional, $params->getValues ($key);
    }
    my $additional = join_pg_array @additional;

    my $result_set = $c->model('BGTrainerDB::BaseForm');
    my $schema = $result_set->result_source->schema;

    $c->stash->{word} = $word;

    eval {
	$schema->txn_begin;

	my %id;
	$id{id} = $id if $id;

	if ($id) {
	    # Check whether the aspects still fit together.
	    my $old = $c->model('BGTrainerDB::BaseForm')->find($id);
	    my $peer_id = $old->peer;

	    if ($peer_id) {
		my $peer = $c->model('BGTrainerDB::BaseForm')->find($peer_id);
		
		my %my_aspect = map { $_ => 1 } @additional;
		my %peer_aspect = 
		    map { $_ => 1 } split_pg_array $peer->additional;

		my $conflict = $self->__isAspectConflict (\%my_aspect,
							  \%peer_aspect);
		if ($conflict) {
		    my $href = $c->uri_for ('/baseform/deletepeer') . "/$id";
		    my $anchor = IWL::Anchor->new
			->setHref($href)
			->setText(__"Delete connection.");
		    my $link = $anchor->getContent;

		    die __x (<<EOF, conflict => $conflict, link => $link);
The change of the verbal aspect is not possible because this would
conflict with the aspect of the verb that this one builds an aspect
pair with. Reason: {conflict}.  You either have to change back the 
aspect, or you can delete the connection by clicking here: {link}
EOF
		}
	    }
	}

	my $baseform = $c->model('BGTrainerDB::BaseForm')->update_or_create({
	    word => $word,
	    category => $category,
	    inflections => $inflections,
	    emphasis => $stresses,
	    additional => $additional,
	    %id,
	});

	if ($id) {
	    $c->model('BGTrainerDB::Word')
		->search (base_id => $id)
		->delete;
	}
	 
	my $category_name = $baseform->category->name;
	my $base_class_name = "BGTrainer::Word::$category_name";

	my %all_forms;
	@inflections = ('') unless @inflections;
	foreach my $inflection (@inflections) {
	    my $class_name = $base_class_name;
	    $class_name .= '::' . $inflection if $inflection;
	    
	    eval "require $class_name";
	    die $@ if $@;
	    
	    my %args = map { $_ => 1 } @additional;
	    my $word_obj = $class_name->new ($word,
					     stresses => \@stresses,
					     %args);
	    my @base_inflections = $word_obj->base_inflections;
	    foreach my $inflection (@base_inflections) {
		my @forms = $word_obj->$inflection (1);

		foreach my $form (@forms) {
		    my @variants = (defined $form && ref $form) ? 
			@$form : $form;
		    foreach my $variant (@variants) {
			next unless defined $variant && length $variant;
			$all_forms{$variant} = 1;
		    }
		}
	    }
	}

	$id = $baseform->id;

	foreach my $form (keys %all_forms) {
	    turn_utf_8_on $form;
	    $c->model('BGTrainerDB::Word')->create({
		base_id => $id,
		word => $form,
	    });		
	}

	my @trans_ids = ($id);
	my $peer_id = $baseform->peer;
	push @trans_ids, $peer_id if $peer_id;

	if ($peer_id) {
	    my $peer = $c->model('BGTrainerDB::Baseform')->find($peer_id);
	    my @peer_additional = grep {
		/^(?:pf|impf)$/;
	    } split_pg_array $peer->additional;
	    push @peer_additional, grep { 
		$_ ne 'pf' && $_ ne 'impf' 
		} @additional;
	    $peer->update ({additional => join_pg_array @peer_additional});
	}

	my $linguas = $c->config->{linguas};
	foreach my $lingua (keys %$linguas) {
	    $lingua =~ s/-.*//;

	    foreach my $base_id (@trans_ids) {
		$c->model("BGTrainerDB::Translation_\U$lingua")
		    ->search (base_id => $base_id)
		    ->delete_all;
		
		my @translations =
		    map {
			s/^[ \t\r\n]+//;
			s/[ \t\r\n]+$//;
			$_;
		    } grep { 
			/[^ \t\r\n]/ 
			} $params->getValues ("translation_$lingua");
		
		next unless @translations;
		
		for (my $idx = 0; $idx <= $#translations; ++$idx) {
		    my @comments = $params->getValues ("comment_${lingua}_$idx");
		    my $comment = join_pg_array @comments;
		    
		    $c->model("BGTrainerDB::Translation_\U$lingua")
			->create ({base_id => $base_id,
				   translation_id => $idx,
				   translation => $translations[$idx],
				   comment => $comment,
			       }),
		    }
	    }
	}
    };

    if ($@) {
	$c->stash->{error_msg} = $@;
	$schema->txn_rollback;
	$c->detach ('edit');
    } else {
	$schema->txn_commit;
    }
    
    $c->response->redirect ($c->uri_for ('/baseform/display') . '/' . $id);
    
    return 1;
}

sub delete : Local {
    my ($self, $c, $id) = @_;

    my $result_set = $c->model('BGTrainerDB::BaseForm');
    my $schema = $result_set->result_source->schema;

    eval {
	$schema->txn_begin;

	my $peer_id = $result_set->find($id)->peer;
	if ($peer_id) {
	    $c->model('BGTrainerDB::BaseForm')->find($peer_id)->update({
		peer => undef,
	    });
	}

	$c->model('BGTrainerDB::BaseForm')
	    ->search(id => $id)
	    ->delete_all;

	$c->model('BGTrainerDB::Word')
	    ->search(base_id => $id)
	    ->delete_all;

	my $linguas = $c->config->{linguas};
	foreach my $lingua (keys %$linguas) {
	    $lingua =~ s/-.*//;
	    $c->model("BGTrainerDB::Translation_\U$lingua")
		->search(base_id => $id)
		->delete_all;
	}
    };
    if ($@) {
	$c->stash->{error} = $@;
	$schema->txn_rollback;
    } else {
	$schema->txn_commit;
    }

    $c->flash->{status_msg} = __"Base form of word deleted.";

    $c->response->redirect($c->uri_for('/word/search'));

    return 1;
}

sub access_denied : Private {
    my ($self, $c) = @_;

    $c->stash->{status_msg} = __"Unauthorized";

    $c->forward ('/word/search');

    return 1;
}

sub frequent : Local {
    my ($self, $c) = @_;

    my $lingua = 'en';
    if ($c->user) {
	$lingua = $c->user->lingua || 'en';
    }
    $lingua =~ s/-.*//;

    my $params = IWL::Stash->new ($c->request->params);

    unless ($params->existsKey ('category')) {
	$params->setValues (category => 0);
    }

    unless ($params->existsKey ('trans')) {
	$params->setValues (trans => 0);
    }

    my %selected_categories = map { $_ => 1 } $params->getValues ('category');
    my %selected_trans = map { $_ => 1 } $params->getValues ('trans');

    if ($selected_categories{0}) {
	%selected_categories = ();
	$params->deleteValues ('category');
    }
    if ($selected_trans{0}) {
	%selected_trans = ();
	$params->deleteValues ('trans');
    }

    my @selected_categories = $params->getValues ('category');
    my @selected_trans = $params->getValues ('trans');

    my $linguas = $c->config->{linguas};

    my @categories = $c->model('BGTrainerDB::Category')->all;
    my %categories = map { $_->id => 1 } @categories;
   
    @selected_categories = grep { exists $categories{$_} } @selected_categories;
    my %trans;
    foreach my $trans (@selected_trans) {
	my $lingua = $trans;
	$lingua =~ s/-.*//;

	$lingua =~ s/^(!)//;
	$trans{$lingua} ||= [];

	push @{$trans{$lingua}}, $1;
    } 

    my @cond;
    while (my ($lingua, $values) = each %trans) {
	next if @$values > 1;
	my $not = $values->[0];
	$not = defined $not ? 'NOT' : '';

	push @cond, ("$not EXISTS (SELECT * FROM translation_$lingua "
		     . "WHERE translation_$lingua.base_id = me.id)");
    }
    my @columns = qw (word);
    push @columns, 'id' if @cond;

    my @where = "1 = 1";
    if (@selected_categories) {
	my $cat_cond = join ' OR ', map { "me.category = $_" } @selected_categories;
	push @where, $cat_cond;
    }
    if (@cond) {
	my $exists = join ' OR ', @cond;
	push @where, $exists;
    }

    my $where = join ' AND ', map { "($_)" } @where;
    my $count = $c->model('BGTrainerDB::BaseForm')->count_literal 
	(
	 $where,
	 {
	     distinct => 1,
	     columns => [@columns],
	 });

    unless ($count) {
	$c->stash->{error_msg} = __"Nothing found!";

	$c->detach ('Root', 'default');

	return 1;
    }

    my $page = $params->getValues ('page') || '0';
    $page =~ s/[^0-9]//g;
    my $rows = $params->getValues ('rows') || '25';
    $rows =~ s/[^0-9]//g;
    $rows = 25 unless $rows >= 1;

    my $start = $page * $rows - $rows + 1;
    if (($start < 1) || ($start > $count)) {
	$start = 1;
	$page = 1;
    }

    $c->stash->{count} = $count;
    $c->stash->{start} = $start;

    my @result = $c->model('BGTrainerDB::BaseForm')->search_literal 
	(
	 $where,
	 {
	     page => $page,
	     rows => $rows,
	     order_by => ['frequency DESC', 'word'],
	     distinct => 1,
	     columns => [@columns, qw (frequency)],
	 }
	 );

    $c->stash->{baseforms} = \@result;

    $c->stash->{template} = 'baseform/frequent.tt2';

    my @get_params = ("rows=$rows");
    foreach my $category (@selected_categories) {
	push @get_params, "category=$category";
    }
    foreach my $trans (@selected_trans) {
	push @get_params, "trans=$trans";
    }
    my $get_params = join '&', @get_params;

    my $pager = IWL::HBox->new;  
    my %style = (margin => '0.2em', 'font-size' => '120%');
    if ($page > 1) {
	my $prev = $page - 1;
	$pager->appendChild (IWL::Anchor
			     ->new (href => "frequent?$get_params&page=$prev")
			     ->setText (__"Previous")
			     ->setStyle (%style));
    }

    my $max_page = 1 + int ($count / $rows);

    for (my $num = $page - 10; $num <= $max_page && $num <= $page + 10;
	 ++$num) {
	next if $num < 1;
	
	if ($num == $page) {
	    $pager->appendChild (IWL::Label
				 ->new
				 ->appendTextType($num, 'strong')
				 ->setStyle (%style));
	} else {
	    $pager->appendChild (IWL::Anchor
				 ->new (href => "frequent?$get_params&page=$num")
				 ->setText ($num)
				 ->setStyle (%style));
	}
    }
    if ($page < $max_page) {
	my $prev = $page + 1;
	$pager->appendChild (IWL::Anchor
			     ->new (href => "frequent?$get_params&page=$prev")
			     ->setText (__"Next")
			     ->setStyle (%style));
    }

    $c->stash->{pager} = $pager->getContent;

    my $form = IWL::Form->new (name => 'frequent',
			       method => 'post',
			       action => '/baseform/frequent');

    my $category_combo = IWL::Combo->new (name => 'category',
					  multiple => 'multiple',
					  size => 3);
    $form->appendChild ($category_combo);
    $category_combo->appendOption (__"all word types", 0, 1);
    foreach my $record (@categories) {
	my $value = $record->id;
	my $name = __($record->long_name);
	$category_combo->appendOption ($name, $value);
    }

    # Only contributors should see this selection.  If you can guess
    # the URI you can still execute the query but that doesn't hurt at all.
    if ($c->check_user_roles ('contributor')) {
	my $trans_combo = IWL::Combo->new (name => 'trans',
					   multiple => 'multiple',
					   size => 3);
	$form->appendChild ($trans_combo);
	$trans_combo->appendOption (__"all", 0, 1);
	foreach my $lingua (sort keys %$linguas) {
	    my $name = $linguas->{$lingua};
	    my $label = __x ("translated into {lingua}", lingua => $name);
	    $trans_combo->appendOption ($label, $lingua);
	    $label = __x ("not translated into {lingua}", lingua => $name);
	    $trans_combo->appendOption ($label, "!$lingua");
	}
    }
    
    $form->appendChild (IWL::Container->new
			    ->appendChild (IWL::Input->new (type => 'submit',
							    style => 'float: right')));

    $form->applyState ($params);

    $c->stash->{form} = $form->getContent;

    return 1;
}

sub __createPeerForm : Private {
    my ($self, $c, $id) = @_;

    my $params = IWL::Stash->new ($c->request->params);

    unless ($id) {
	$id = $params->getValues ('id');
    }

    unless ($id =~ /^[0-9]+$/) {
	$c->detach ('/baseform/search');
    }

    $params->setValues (id => $id);
	
    my $me = $c->model('BGTrainerDB::BaseForm')->find ($id, {
	columns => [qw (word category peer additional)],
    });
    
    unless ($me) {
	$c->stash->{error_msg} = __"No such word!";
	$c->detach ('display', [$id]);
    }
    
    my %my_aspects = map { $_ => 1 } split_pg_array $me->additional;
    unless ($my_aspects{pf} || $my_aspects{impf}) {
	$c->stash->{error_msg} = __"Set aspect of this word first!";
	$c->detach ('display', [$id]);
    }

    my $word = $me->word;
    my $category = $me->get_column ('category');

    my $catname = $me->category->name;
    unless ('Verb' eq $catname) {
	$c->stash->{error_msg} = __"Only verbs can build aspect pairs.";
	$c->detach ('display', [$id]);
	return 1;
    }

    my $old_peer = $me->peer;
    if ($old_peer) {
	$c->stash->{error_msg} = __("You have to delete the existing "
				    . "relationship first.");
	$c->detach ('display', [$id]);
	return 1;
    }

    clean_params $params, 1;

    my $form = IWL::Form->new (action => '/baseform/savepeer', 
			       method => 'post',
			       name => 'edit_peer');

    # This will also turn a 0 into the empty string, who cares.
    $form->appendChild (IWL::Hidden->new (name => 'word'));
    $id = $params->getValues ('id');
    $form->appendChild (IWL::Hidden->new (name => 'id',
					  value => $id));

    my $vbox = IWL::Container->new;
    $form->appendChild ($vbox);

    my $hbox = IWL::HBox->new;
    $vbox->appendChild ($hbox);
    $hbox->appendChild (IWL::Input->new (name => 'search'));
    $hbox->appendChild (IWL::Input->new (name => 'do_search',
					 value => __"Search",
					 type => 'submit'));

    if ($params->getValues ('do_search') && $params->getValues ('search')) {
	my $search = $params->getValues ('search');
        $search = bg_tolower $search;
	my @hits = $c->model('BGTrainerDB::Word')->search 
	    ({
		'me.word' => $search,
	    },
	     {
		 where => { 'base_id.category' => $category,
			    'base_id.id' => { '!=' => $id }},
		 include_columns => ['base_id.word', 'base_id.category',
				     'base_id.peer', 'base_id.additional'],
		 join => ['base_id'],
	     },
	     );

	unless (@hits) {
	    $c->stash->{error_msg} = __"Nothing appropriate found!";
	}

	foreach my $hit (@hits) {
	    my $base_id = $hit->base_id->id;

	    my $dummy = IWL::Container->new;
	    $vbox->appendChild ($dummy);

	    my %aspects = map { $_ => 1 }
		split_pg_array $hit->base_id->additional;
	    my $conflict = $self->__isAspectConflict (\%my_aspects, \%aspects);

	    my $link = IWL::Anchor->new;
	    $link->setText ($hit->word);
	    $link->setHref ($c->uri_for ('/baseform/display') . "/$base_id");

	    if ($conflict) {
		$dummy->appendChild ($link);
		
		my $label = IWL::Label->new;
		$dummy->appendChild ($label);
		$label->appendText (' ');
		$label->appendTextType ($conflict, 'em');
	    } else {
		my $radio = IWL::RadioButton->new (name => 'peer',
						   value => $base_id);
		$dummy->appendChild ($radio);
		$dummy->appendChild ($link);
	    }
	}
    }

    my $submit = IWL::Input->new (name => 'do_save',
				  value => __"Save",
				  type => 'submit');

    $vbox->appendChild ($submit);

    $form->applyState ($params);

    return $form->getContent;
}

sub __isAspectConflict : Private {
    my ($self, $a1, $a2) = @_;

    return __"Aspectless verbs cannot build pairs!"
	unless ($a1->{pf} || $a1->{impf});
    return __"Aspectless verbs cannot build pairs!"
	unless ($a2->{pf} || $a2->{impf});
    return __"Verbs are both perfective!" if ($a1->{pf} && $a2->{pf});
    return __"Verbs are both imperfective!" if ($a1->{impf} && $a2->{impf});

    return;
}

1;
