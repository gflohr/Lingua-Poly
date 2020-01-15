package BGTrainer::Controller::Training;

use strict;
use warnings;
use base 'Catalyst::Controller';
use BGTrainer::Training::VocabularyFrom;
use Locale::TextDomain qw (net.guido-flohr.bgtrainer);
use Locale::Messages qw (turn_utf_8_on);

use IWL::Stash;

sub index : Private {
    my ($self, $c) = @_;

    $c->response->body('Matched BGTrainer::Controller::Training in Training.');
}

sub start : Local {
    my ($self, $c, $lesson_name) = @_;

    $c->stash->{lesson} = $lesson_name;
    my $lesson = $self->__loadLesson ($c, $lesson_name);

    unless ($lesson->isStarted) {
    }

    my $params = IWL::Stash->new ($c->request->params);

    if ($params->getValues ('new')) {
	$self->__initLesson ($c, $lesson);
    }

    $c->stash->{template} = 'training/start.tt2';

    return 1;
}

sub delete : Local {
    my ($self, $c, $lesson_name) = @_;

    my $uid = $c->user->get_column ('id');

    # Ensure a valid lesson name.
    $self->__loadLesson ($c, $lesson_name);

    my $result_set = $c->model ('BGTrainerDB::Training');
    my $schema = $result_set->result_source->schema;

    eval {
	$schema->txn_begin;

	$result_set->search (user_id => $uid, 
			     type => $lesson_name)->delete_all;
    };
    if ($@) {
	warn $@;
	$c->stash->{error_msg} = __("Error deleting your trainings unit,"
				    . " please try again later.");
	$schema->txn_rollback;
	$c->response->redirect ($c->uri_for ('/'));
    } else {
	$schema->txn_commit;
    }

    $c->flash->{status_msg} = __"Trainings unit deleted!";

    $c->response->redirect ($c->uri_for ('/'));
}

sub __loadLesson {
    my ($self, $c, $lesson_name) = @_;

    unless ($lesson_name =~ /^([A-Za-z_][A-Za-z0-9_]*)$/) {
	$c->flash->{error_msg} = __"Invalid training unit";
	$c->response->redirect($c->uri_for('/'));
    }
    
    $lesson_name = ucfirst $lesson_name;
    $lesson_name =~ s/_(.)/uc $1/ge;

    my $class_name = 'BGTrainer::Training::' . $lesson_name;

    eval "use $class_name";
    my $lesson = eval { $class_name->new } unless $@;
    if ($@) {
	warn "Error loading class '$class_name': $@";
	$c->flash->{error_msg} = __"Invalid training unit";
	$c->response->redirect ($c->uri_for ('/'));
    }
    
    return $lesson;
}

sub __initLesson {
    my ($self, $c, $lesson) = @_;

    my $num_words = 1_000_000;
    my $random = 0;

    my $uid = $c->user->get_column ('id');

    my $words = $lesson->getWords ($c, $num_words, $random);

    my $result_set = $c->model ('BGTrainerDB::Training');
    my $schema = $result_set->result_source->schema;

    eval {
	$schema->txn_begin;

	$result_set->search (user_id => $uid, 
			     type => $lesson->getName)->delete_all;
	
	$result_set->create ({
	    user_id => $uid,
	    type => $lesson->getName,
	    words => scalar @$words});

	my $id = $result_set->find ({ user_id => $uid, 
				      type => $lesson->getName })->id;

	foreach my $word (@$words) {
	    $c->model ('BGTrainerDB::TrainingData')
		->create ({
		    id => $id,
		    word => $word,
		    level => 0});
	}
    };
    if ($@) {
	warn $@;
	$c->stash->{error_msg} = __("Error creating your trainings unit,"
				    . " please try again later.");
	$schema->txn_rollback;
	$c->response->redirect ($c->uri_for ('/'));
    } else {
	$schema->txn_commit;
    }

    return 1;
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
