package BGTrainer::Controller::Login;

use strict;
use warnings;
use base 'Catalyst::Controller';

use Locale::TextDomain qw (net.guido-flohr.bgtrainer);

=head1 NAME

BGTrainer::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index : Private {
    my ($self, $c) = @_;

    my $email_address = $c->request->params->{email_address} || '';
    my $password = $c->request->params->{password} || '';

    if ($email_address && $password) {
	if ($c->login($email_address, $password)) {
	    $c->response->redirect($c->uri_for('/word/search'));
	    return;
	} else {
	    $c->stash->{error_msg} = __"Bad e-mail address or password.";
	}
    }
 
    $c->response->redirect ($c->uri_for ('/'));
     
    return 1;
}


=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
