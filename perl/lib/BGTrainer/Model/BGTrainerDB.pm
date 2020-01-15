package BGTrainer::Model::BGTrainerDB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'BGTrainerDB',
    connect_info => [
        'dbi:Pg:dbname=re4nik',
        '',
        '',
        {AutoCommit => 0, PrintError => 1, RaiseError => 1},
        
    ],
);

=head1 NAME

BGTrainer::Model::BGTrainerDB - Catalyst DBIC Schema Model
=head1 SYNOPSIS

See L<BGTrainer>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<dbi:Pg:dbname=re4nik>

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
