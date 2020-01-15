package BGTrainer::View::TT;

use strict;
use base 'Catalyst::View::TT::ForceUTF8';

__PACKAGE__->config({
    CATALYST_VAR => 'Catalyst',
    INCLUDE_PATH => [
        BGTrainer->path_to( 'root', 'src' ),
        BGTrainer->path_to( 'root', 'lib' )
    ],
    PRE_PROCESS  => 'config/main',
    WRAPPER      => 'site/wrapper',
    ERROR        => 'error.tt2',
    TIMER        => 0
});

=head1 NAME

BGTrainer::View::TT - Catalyst TTSite View

=head1 SYNOPSIS

See L<BGTrainer>

=head1 DESCRIPTION

Catalyst TTSite View.

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

