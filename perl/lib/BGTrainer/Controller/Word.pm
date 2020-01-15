package BGTrainer::Controller::Word;

use strict;
use warnings;
use base 'Catalyst::Controller';

use Locale::TextDomain qw (net.guido-flohr.bgtrainer);
use Locale::Messages qw (turn_utf_8_on);

use BGTrainer::Case qw (bg_tolower bg_lower);
use BGTrainer::Util qw (bg_word);

=head1 NAME

BGTrainer::Controller::Word - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index : Private {
    my ($self, $c) = @_;

    $c->response->body('Matched BGTrainer::Controller::Word in Word.');
}

sub design : Local {
    my ($self, $c) = @_;

    $c->stash->{template} = 'word/design.tt2';

    $c->stash->{status_msg} = <<EOF;
So sehen Status-Meldungen aus, kurze Mitteilungen an den Benutzer,
Warnungen und so weiter.
EOF

    $c->stash->{error_msg} = <<EOF;
Fehlermeldungen müssen etwas deutlicher herausstechen.
EOF

    return 1;
}

sub search : Local {
    my ($self, $c) = @_;

    $c->stash->{template} = 'word/search.tt2';

    return 1;
}

sub search_do : Local {
    my ($self, $c) = @_;

    # In case of errors we don't have to set it.
    $c->stash->{template} = 'word/search.tt2';

    my $params = $c->request->params;
    my $word = $params->{word};
    turn_utf_8_on $word;
    $word = bg_tolower $word;

    if (defined $word) {
	$word =~ s/^[ \t]+//;
	$word =~ s/[ \t]+$//;
    }

    unless (defined $word && length $word) {
	$c->{stash}->{error_msg} = __"No word given.";
	return 1;
    }
    
    $c->stash->{baseforms} = [$c->model('BGTrainerDB::Word')->search({
	word => $word
	})];
    
    my $num_words = $c->stash->{num_words} = @{$c->stash->{baseforms}};
    
    if (!$num_words) {
	$c->{stash}->{error_msg} = __x("Nothing found for '{word}'.",
				       word => $word);
	return 1;
    } elsif (1 == $num_words) {
	my $id = $c->stash->{baseforms}->[0]->get_column ('base_id');
	$c->response->redirect ($c->uri_for ('/baseform/display/') . $id);
    }

    $c->stash->{template} = 'word/search_result.tt2';
    $c->stash->{word} = $params->{word};

    return 1;
}

sub browse : Local {
    my ($self, $c, $partial) = @_;

    turn_utf_8_on $partial;
    $partial = '' unless defined $partial;
    $partial = '' unless bg_word $partial;
    $partial = bg_tolower $partial;

    my @bg_letters = sort '-', bg_lower;

    my @navparts;

    foreach my $letter (@bg_letters) {
	my $navpart = $partial . $letter;

	my @hits = $c->model('BGTrainerDB::Word')->search_like ({
	    'me.word' => $navpart . '%',
	},{
	    page => 0,
	    rows => 1,
	});
	next unless @hits;

	push @navparts, $partial . $letter;
    }

    $c->stash->{navparts} = \@navparts;

    my @hits = $c->model('BGTrainerDB::Word')->search_like ({
	'me.word' => $partial . '%',
    },{
	select => [
		   'me.base_id',
		   'me.word',
		   'base_id.word',
		   'category.name',
		   ],
	    as => [
		   'base_id', 'word', 'baseform', 'category',
		   ],
	page => 0,
	rows => 20,
	order_by => 'me.word',
	join => { base_id => 'category',  },
    });

    $c->stash->{hits} = \@hits;
    $c->stash->{template} = 'word/browse.tt2';

    return 1;
}

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

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
