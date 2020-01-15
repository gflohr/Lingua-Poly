package BGTrainer::Controller::Category;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

BGTrainer::Controller::Category - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index : Private {
    my ($self, $c) = @_;

    $c->response->body('Matched BGTrainer::Controller::Category in Category.');
}

sub list : Local {
    my ($self, $c) = @_;

    $c->stash->{categories} = [$c->model('BGTrainerDB::Category')->all];

    $c->stash->{template} = 'category/list.tt2';

    return 1;
}

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
