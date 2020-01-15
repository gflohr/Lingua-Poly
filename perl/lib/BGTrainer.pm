package BGTrainer;

use strict;
use warnings;

use Catalyst::Runtime '5.70';

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a YAML file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root 
#                 directory

use Catalyst qw/
    ConfigLoader 
    Static::Simple
    
    Authentication
    Authentication::Store::DBIC
    Authentication::Credential::Password
    Authorization::Roles
    Authorization::ACL

    Session
    Session::Store::FastMmap
    Session::State::Cookie
/;

our $VERSION = '0.01';

# Configure the application. 
#
# Note that settings in BGTrainer.yml (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with a external configuration file acting as an override for
# local deployment.

__PACKAGE__->config( name => 'BGTrainer' );
__PACKAGE__->config->{static}->{dirs} = [
					 'static',
					 ];
__PACKAGE__->config->{static}->{include_path} = [
						 __PACKAGE__->config->{root},
						 ];

# Start the application
__PACKAGE__->setup;

# Authorization::ACL Rules
#__PACKAGE__->deny_access_unless('/account/confirm',
#				);

__PACKAGE__->deny_access ('/account');
__PACKAGE__->allow_access ('/account/confirm');
__PACKAGE__->allow_access_if ('/account/create',
			      sub { !shift->user_exists });
__PACKAGE__->allow_access_if ('/account/email_address',
			      'user_exists');
__PACKAGE__->allow_access_if ('/account/email_address_do',
			      'user_exists');
__PACKAGE__->allow_access_if ('/account/forgotten',
			      sub { !shift->user_exists });
__PACKAGE__->allow_access_if ('/account/forgotten_do',
			      sub { !shift->user_exists; });
__PACKAGE__->allow_access_if ('/account/password',
			      'user_exists');
__PACKAGE__->allow_access_if ('/account/personal',
			      'user_exists');
__PACKAGE__->allow_access_if ('/account/save_create',
			      sub { !shift->user_exists });
__PACKAGE__->allow_access_if ('/account/save_password',
			      'user_exists');
__PACKAGE__->allow_access_if ('/account/save_personal',
			      'user_exists');
__PACKAGE__->allow_access_if ('/account/unregister',
			      'user_exists');
__PACKAGE__->allow_access_if ('/account/unregister_do',
			      'user_exists');

__PACKAGE__->deny_access_unless(
				"/baseform/delete",
				[qw/user contributor/],
				);
__PACKAGE__->deny_access_unless(
				"/baseform/edit",
				[qw (user contributor)],
				);
__PACKAGE__->deny_access_unless(
				"/baseform/editpeer",
				[qw (user contributor)],
				);
__PACKAGE__->deny_access_unless(
				"/baseform/deletepeer",
				[qw (user contributor)],
				);
__PACKAGE__->deny_access_unless(
				"/baseform/savepeer",
				[qw (user contributor)],
				);
__PACKAGE__->deny_access_unless(
				"/baseform/save",
				[qw/user contributor/],
				);


=head1 NAME

BGTrainer - Catalyst based application

=head1 SYNOPSIS

    script/bgtrainer_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<BGTrainer::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
