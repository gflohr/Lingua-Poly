package BGTrainer::Controller::Parse;

use strict;
use warnings;
use base 'Catalyst::Controller';
use IWL;
use BGTrainer::Util qw (escape_html bg_cleanwordsplit bg_word split_pg_array);
use BGTrainer::Case qw (bg_tolower);
use Locale::Messages qw (turn_utf_8_on);

=head1 NAME

BGTrainer::Controller::Parse - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index : Private {
    my ( $self, $c ) = @_;

    $c->response->body('Matched BGTrainer::Controller::Parse in Parse.');
}

sub input : Local {
    my ($self, $c) = @_;

    $c->stash->{template} = 'parse/input.tt2';

    return 1;
}

sub result : Local {
    my ($self, $c) = @_;

    $c->stash->{template} = 'parse/result.tt2';

    my $params = IWL::Stash->new ($c->request->params);

    my $input = $params->getValues ('input');
    turn_utf_8_on $input;
    $input =~ tr/\xad//d;

    my $words = bg_cleanwordsplit $input, 1, 1;

    my @result;
    foreach my $word (@$words) {
	turn_utf_8_on $word;
	my $normalized = bg_tolower $word;
	my $is_bg_word = bg_word $word, 1;
	my $exists;

	if ($is_bg_word) {
	    my @rs = $c->model('BGTrainerDB::Word')->search({
		word => $normalized,
	    });

	    if (@rs) {
		$exists = 1;
		my @base_ids;
		foreach my $rs (@rs) {
		    my ($word, $id) = $rs->id;
		    push @base_ids, $id;
		}
		$word = $self->__emphasize ($c, $word, @base_ids);
	    }
	}

	if ($exists) {
	    my $anchor = IWL::Anchor->new;
	    $anchor->setAttribute (href => "/word/search_do?word=$normalized",
				   'none');
	    $anchor->setText ($word);
	    my $content = $anchor->getContent;
	    turn_utf_8_on $content;
	    chomp $content;
	    push @result, $content;
	} elsif ($is_bg_word) {
	    my $container = IWL::Container->new (inline => 1,
						 class => 'missing');
	    my $text = IWL::Text->new ($word);
	    $container->appendChild ($text);
	    my $content = $container->getContent;
	    chomp $content;
	    push @result, $content;
	} else {
	    push @result, escape_html $word;
	}
    }

    my $result = join '', @result;
    $result =~ s,\n,<br />,g;

    $c->stash->{result} = $result;

    return 1;
}

sub __emphasize {
    my ($self, $c, $word, @base_ids) = @_;

    my $normalized = bg_tolower $word;

    my $result;
    foreach my $base_id (@base_ids) {
	my $rs = $c->model('BGTrainerDB::Baseform')->find ($base_id);
	
	my $baseform = $rs->word;
	my $category = $rs->category->name;

	my @stresses = split_pg_array $rs->emphasis;

	my @inflections = split_pg_array $rs->inflections;
	@inflections = ('') unless @inflections;

	my @additional = split_pg_array $rs->additional;

	my $base_class_name = "BGTrainer::Word::$category";

	foreach my $inflection (@inflections) {
	    my $class_name = $base_class_name;
	    $class_name .= '::' . $inflection if $inflection;
	    
	    eval "require $class_name";
	    next if $@;

	    my %args = map { $_ => 1 } @additional;

	    my $word_obj = $class_name->new ($baseform,
					     stresses => \@stresses,
					     %args);
	    my @base_inflections = $word_obj->base_inflections;
	    foreach my $inflection (@base_inflections) {
		my @forms = $word_obj->$inflection (1);
		my $idx = -1;
		foreach my $form (@forms) {
		    ++$idx;
		    next unless defined $form && length $form;
		    next unless $form eq $normalized;

		    my $word_obj2 = $class_name->new ($baseform,
						      stresses => \@stresses,
						      %args);
		    $word_obj2->setEmphasizer (sub {'[' . $_[0] . ']'});
		    my @emphasized = $word_obj2->$inflection (1);
		    my $emphasized = $emphasized[$idx];
		    if ($result) {
			return $word if $emphasized ne $result;
		    }

		    $result = $emphasized;
		}
	    }
	}
    }

    if ($result) {
	my @mixed = split '', $word;
	my @lower = split '', $result;

	my $result = '';

	while (@lower) {
	    my $lower = shift @lower;
	    if ('[' eq $lower) {
		$result .= '<u>';
	    } elsif (']' eq $lower) {
		$result .= '</u>';
	    } else {
		$result .= shift @mixed;
	    }
	}

	return $result;
    }

    return $word;
}

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
