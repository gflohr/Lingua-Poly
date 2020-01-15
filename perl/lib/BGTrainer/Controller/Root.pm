package BGTrainer::Controller::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';

use Locale::Util qw (web_set_locale);
use Locale::Messages qw (bind_textdomain_filter bind_textdomain_codeset
			 turn_utf_8_on nl_putenv);
use IO::Handle;
use utf8;

BEGIN {
        bind_textdomain_filter 'net.guido-flohr.bgtrainer', \&turn_utf_8_on;
        bind_textdomain_codeset 'net.guido-flohr.bgtrainer', 'utf-8';
	Locale::Messages::nl_putenv ('OUTPUT_CHARSET=utf-8');

	binmode STDOUT, ':utf8';
}

use IWL::Object;

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

sub default : Private {
    my ($self, $ctx) = @_;

    $ctx->stash->{template} = 'root.tt2';

    return 1;
}

sub auto : Private {
    my ($self, $c) = @_;

    # Clear caches etc.
    IWL::Object->cleanStateful;

    my $lingua = 'en-US';
    $lingua = $c->user->lingua if $c->user && $c->user->lingua;
    $self->__setLingua ($c, $lingua);

    if ($c->user) {
	my $result_set = $c->model('BGTrainerDB::User');
	my $schema = $result_set->result_source->schema;
	$schema->txn_begin;

	eval {
	    $c->user->update ({ last_seen => 'NOW()' });
	};
	
	if ($@) {
	    $schema->txn_rollback;
	} else {
	    $schema->txn_commit;
	}    
    }

    # User found, so return 1 to continue with processing after this 'auto'
    return 1;
}

sub end : ActionClass('RenderView') {}

sub imprint : Local {
    my ($self, $c) = @_;

    $c->stash->{template} = 'imprint.tt2';

    return 1;
}

sub __setLingua : Private {
    my ($self, $c) = @_;

    my $lingua;
    if ($c->user && $c->user->lingua) {
	$lingua = $c->user->lingua;
    }

    my $session = $c->session;
    if ($session->{lingua}) {
	$lingua = $session->{lingua};
    }

    nl_putenv ('LANGUAGE');
    nl_putenv ('LANG');
    nl_putenv ('LC_ALL');

    unless (defined $lingua && web_set_locale $lingua, 'utf-8') {
	web_set_locale 'en-US', 'utf-8';
    }

    return 1;
}

1;
