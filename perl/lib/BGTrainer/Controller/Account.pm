package BGTrainer::Controller::Account;

use strict;
use warnings;
use base 'Catalyst::Controller';

use Locale::TextDomain qw (net.guido-flohr.bgtrainer);
use Locale::Messages qw (turn_utf_8_on);
use Net::SMTP;
use Digest::SHA qw (sha1_hex);

use IWL;
use IWL::Config qw (%IWLConfig);

use BGTrainer::Mail qw (normalize_email_address sendmail);

=head1 NAME

BGTrainer::Controller::Account - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index : Private {
    my ( $self, $c ) = @_;

    $c->response->body('Matched BGTrainer::Controller::Account in Account.');
}

sub personal : Local {
    my ($self, $c) = @_;

    my $email_address = $c->user->email_address;

    $c->stash->{form} = $self->__createChangeForm ($c, $email_address);
    $c->stash->{template} = 'account/personal.tt2';

    return 1;
}

sub password : Local {
    my ($self, $c) = @_;

    my $email_address = $c->user->email_address;

    $c->stash->{form} = $self->__createPasswordForm ($c, $email_address);
    $c->stash->{template} = 'account/personal.tt2';

    return 1;
}

sub create : Local {
    my ($self, $c) = @_;

    $c->stash->{form} = $self->__createForm ($c);
    $c->stash->{template} = 'account/personal.tt2';

    return 1;
}

sub unregister : Local {
    my ($self, $c) = @_;

    my $form = IWL::Form->new (action => $c->uri_for ('unregister_do'),
			       name => 'unregister',
			       method => 'POST');

    # FIXME: This is a nuisance.
    my $skin_js = IWL::Script->new;
    $form->appendChild ($skin_js);

    my $skin_dir = $IWLConfig{SKIN_DIR};

    $skin_js->appendScript ("var skin_dir = '$skin_dir'\n");

    my $text = __(<<EOF);
Unregistering will delete all your saved sessions and other personal
data.  Do you want to proceed?
EOF

    $form->appendChild (IWL::Text->new ($text));
    my $cancel = IWL::Anchor->new;
    $cancel->setHref ($c->uri_for ('/'));
    $cancel->setText (__"Cancel");
    $form->appendChild ($cancel);

    my $submit = IWL::Input->new (type => 'submit',
				  name => 'okay', 
				  value => __"Okay");
    $form->appendChild ($submit);

    $c->stash->{form} = $form->getContent;
    $c->stash->{template} = 'account/personal.tt2';

    return 1;
}

sub unregister_do : Local {
    my ($self, $c) = @_;

    my $result_set = $c->model('BGTrainerDB::User');
    my $schema = $result_set->result_source->schema;
    $schema->txn_begin;

    my $user = $result_set->find($c->user->id,
				 { key => 'users_email_address' });
    eval {
	$user->delete;
	my $mapped_roles = $user->related_resultset ('map_user_role');
	$mapped_roles->delete_all;
    };

    if ($@) {
	$c->stash->{error_msg} = $@;
	$schema->txn_rollback;
	$c->detach ('Root', 'default');
    } else {
	$schema->txn_commit;
    }

    $c->logout;
    $c->stash->{status_msg} = __"Unregistering successul!";
    $c->detach ('Logout', 'index');

    return 1;
}

sub confirm : Local {
    my ($self, $c, $id) = @_;

    unless (defined $id && length $id == 40) {
	$c->stash->{error_msg} = __("Invalid request.  Please copy "
				    . "the address from your confirmation "
				    . "mail again.");
	$c->detach ('Root', 'default');
	return 1;
    }

    my $result = $c->model('BGTrainerDB::Request')->find($id);
    unless ($result) {
	$c->stash->{error_msg} = __("Invalid request.  Confirmation links "
				    . "have to be followed within 72 hours.");
        $c->detach ('Root', 'default');
	return 1;
    }

    my %request = (email_address => $result->email_address,
		   password => $result->password,
		   first_name => $result->first_name,
		   last_name => $result->last_name,
		   lingua => $result->lingua);
		   
    foreach my $key (keys %request) {
	my $value = $request{$key};
	delete $request{$key} unless defined $value && length $value;
    }

    my $result_set = $c->model('BGTrainerDB::User');
    my $schema = $result_set->result_source->schema;
    $schema->txn_begin;

    my $user_id = $result->user_id;
    my $email_address = $request{email_address};
    my $password = $request{password};
    if ($email_address) {
	my $exists = $c->model('BGTrainerDB::User')->find($email_address, {
	    key => 'users_email_address',
	});
	if ($exists) {
	    $c->stash->{error_msg} = __("The specified e-mail address "
					. "is already registered.  Did you "
					. "register multiple times?");
	    $schema->txn_rollback;
	    $c->detach ('Root', 'default');
	}
    }

    eval {
	my %r = %request;
	$r{password} = sha1_hex $password if defined $password;

	if ($user_id) {
	    $r{id} = $user_id;
	    $c->model('BGTrainerDB::User')->update ({%r});
	} else {
	    my $user = $c->model('BGTrainerDB::User')->create ({%r});

	    my $role = $c->model('BGTrainerDB::Role')->find 
		('user',
		 { key => 'roles_rolename' });
	    my $role_id = $role->id;
							     
	    $user->add_to_map_user_role ({ role_id => $role_id });
	}
	
	$result->delete ($id);
    };

    if ($@) {
	$c->stash->{error_msg} = $@;
	$schema->txn_rollback;
	$c->detach ('Root', 'default');
    } else {
	$schema->txn_commit;
    }    

    if ($email_address && $password) {
	$c->login ($email_address, $password) or die;
	$c->stash->{status_msg} = __"Confirmation successful!";
    } else {
	$c->logout;
	$c->stash->{status_msg} = __"You must re-login with your new address!";
    }

    $c->detach ('Root', 'default');
    
    return 1;
}

sub save_personal : Local {
    my ($self, $c) = @_;

    my $params = IWL::Stash->new ($c->request->params);

    my %request;
    foreach my $prop (qw (first_name last_name lingua)) {
	$request{$prop} = $params->getValues ($prop);
    }

    my $result_set = $c->model('BGTrainerDB::User');
    my $schema = $result_set->result_source->schema;
    $schema->txn_begin;

    eval {
	$c->user->update ({%request});
    };

    if ($@) {
	$c->stash->{error_msg} = $@;
	$schema->txn_rollback;
	$c->detach ('Root', 'default');
    } else {
	$schema->txn_commit;
    }    

    $c->stash->{status_msg} = __"New personal data saved!";

    $c->detach ('Root', 'default');
    
    return 1;
}

sub save_password : Local {
    my ($self, $c) = @_;

    my $params = IWL::Stash->new ($c->request->params);

    my $dirty = $params->getValues ('dirty');
    unless ($dirty) {
	$c->stash->{error_msg} = __"Internal error!";
	$c->detach ('password');
	return 1;
    }

    my $old_password = $params->getValues ("old_password_$dirty");
    unless (defined $old_password && length $old_password) {
	$c->stash->{error_msg} = __"You must specify your old password!";
	$c->detach ('password');
	return 1;
    }
    $old_password = sha1_hex $old_password;
    unless ($old_password eq $c->user->password) {
	$c->stash->{error_msg} = __"Your old password is not correct!";
	$c->detach ('password');
	return 1;
    }

    my $password = $params->getValues ("password_$dirty");
    unless (defined $password && length $password) {
	$c->stash->{error_msg} = __"You must specify a new password!";
	$c->detach ('password');
	return 1;
    }

    my $password2 = $params->getValues ("password2_$dirty");
    unless (defined $password2 && length $password2
	    && $password eq $password2) {
	$c->stash->{error_msg} = __"Passwords do not match!";
	$c->detach ('password');
	return 1;
    }

    my $result_set = $c->model('BGTrainerDB::User');
    my $schema = $result_set->result_source->schema;
    $schema->txn_begin;

    eval {
	$c->user->update ({password => sha1_hex $password});
    };

    if ($@) {
	$c->stash->{error_msg} = $@;
	$schema->txn_rollback;
	$c->detach ('Root', 'default');
    } else {
	$schema->txn_commit;
    }    

    $c->stash->{status_msg} = __"Password changed!";

    $c->detach ('Root', 'default');
    
    return 1;
}

sub save_create : Local {
    my ($self, $c) = @_;

    my $params = IWL::Stash->new ($c->request->params);

    my $dirty = $params->getValues ('dirty');
    unless ($dirty) {
	$c->stash->{error_msg} = __"Internal error!";
	$c->detach ('create');
	return 1;
    }

    my $first_name = $params->getValues ('first_name');
    $first_name = '' unless defined $first_name;
    turn_utf_8_on $first_name;
    $first_name =~ s/^\s+//;
    $first_name =~ s/\s+$//;

    my $last_name = $params->getValues ('last_name');
    $last_name = '' unless defined $last_name;
    turn_utf_8_on $last_name;
    $last_name =~ s/^\s+//;
    $last_name =~ s/\s+$//;

    my $lingua = $params->getValues ('lingua');
    unless (exists $c->config->{linguas}->{$lingua}) {
	$lingua = 'en-US';
    }

    my $email_address = $params->getValues ('email_address');
    $email_address = normalize_email_address $email_address;
    unless ($email_address) {
	$c->stash->{error_msg} = __"Invalid e-mail address!";
	$c->detach ('create');
	return 1;
    }

    my $exists = $c->model('BGTrainerDB::User')->find
	($email_address,
	 {
	     key => 'users_email_address',
	 });
    if ($exists) {
	$c->stash->{error_msg} = __("The specified e-mail address is already "
				    . "registered!");
	$c->detach ('create');
    }

    my $password = $params->getValues ("password_$dirty");
    my $password2 = $params->getValues ("password2_$dirty");
    unless (defined $password && length $password) {
	$c->stash->{error_msg} = __("Please specify a password!");
	$c->detach ('create');
	return 1;
    }

    if ($password =~ / /) {
	$c->stash->{error_msg} = __("Password must not contain spaces!");
	$c->detach ('create');
	return 1;
    }

    if (length $password < 5) {
	$c->stash->{error_msg} = __("Password must have at least 5 characters!");
	$c->detach ('create');
	return 1;
    }

    if ($password ne $password2) {
	$c->stash->{error_msg} = __("Passwords do not match!");
	$c->detach ('create');
	return 1;
    }

    my @gmtime = gmtime;
    my $timestamp = sprintf ("%04d-%02d-%02d %02d:%02d:%02d",
			     $gmtime[5] + 1900,
			     $gmtime[4] + 1,
			     $gmtime[3],
			     $gmtime[2], $gmtime[1], $gmtime[0]);

    my $request = {
		   timestamp => $timestamp,
		   email_address => $email_address,
		   password => $password,
		   first_name => $first_name,
		   last_name => $last_name,
		   };

    my $digest_string = $c->config->{secret};
    foreach my $key (sort keys %$request) {
	my $value = $request->{$key};
	next unless defined $value && length $value;
	$digest_string .= $request->{$key};
    }
    $request->{id} = sha1_hex $digest_string;

    my $result_set = $c->model('BGTrainerDB::Request');
    my $schema = $result_set->result_source->schema;
    eval {
	$schema->txn_begin;
	$c->model('BGTrainerDB::Request')->create($request);
    };

    if ($@) {
	$c->stash->{error_msg} = __"Internal error, please try again later!";
	$schema->txn_rollback;
	$c->detach ('create');
    } else {
	$schema->txn_commit;
    }
    
    my $link = $c->request->base;

    $link .= "account/confirm/$request->{id}";

    my $data = __x(<<EOF, base => $c->request->base, link => $link);
Hi,

somebody, hopefully you, has requested registration for the site
{base}.

If you don\'t want to register, simply ignore this mail.  Otherwise
proceed with your registration by following this link:

  {link}

Please register within the next 72 hours.

Yours sincerely,
BGTrainer
EOF

    my $language = $lingua;
    $language =~ s/-.*//;

    my %mail = (
		to => $email_address,
		first_name => $first_name,
		last_name => $last_name,
		subject => __"Please confirm registration",
		data => $data,
		from_domain => $c->config->{mail}->{from_domain},
		language => $language,
		);

    unless (sendmail %mail) {
	$c->{stash}->{error_msg} = <<EOF;
Sorry, an error has occurred sending your mail.  Please try again later!
EOF
        $c->detach ('create');
	return 1;
    }

    $c->stash->{template} = 'account/mailsent.tt2';
    $c->stash->{recipient} = $email_address;
    $c->stash->{the_link} = $link;

    return 1;
}

sub __createForm : Private {
    my ($self, $c) = @_;

    my $params = IWL::Stash->new ($c->request->params);

    my $form = IWL::Form->new (action => '/account/save_create', 
			       method => 'post',
			       name => 'personal_data');

    # FIXME: This is a nuisance.
    my $skin_js = IWL::Script->new;
    $form->appendChild ($skin_js);

    my $skin_dir = $IWLConfig{SKIN_DIR};

    $skin_js->appendScript ("var skin_dir = '$skin_dir'\n");

    unless ($params->getValues ('dirty')) {
	my $dirty = sprintf '%04x%04x', (int rand 0x10000), (int rand 0x10000);
	$params->setValues (dirty => $dirty);
    }

    my $dirty = $params->getValues ('dirty');
    $form->appendChild (IWL::Hidden->new (name => 'dirty',
					  value => $dirty));

    my $table = IWL::Table->new (cellspacing => 1,
				 cellpadding => 1);
    $form->appendChild ($table);

    my @rows;
    my $row;

    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell (__"E-mail address");
    $row->appendCell (IWL::Input->new (name => 'email_address'));

    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell (__"First name");
    $row->appendCell (IWL::Input->new (name => 'first_name'));

    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell (__"Last name");
    $row->appendCell (IWL::Input->new (name => 'last_name'));

    # Prevent browsers from auto-filling the field.
    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell (__"Password");
    $row->appendCell (IWL::Input->new (name => "password_$dirty",
				       type => 'password'));
    
    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell (__"Repeat password");
    $row->appendCell (IWL::Input->new (name => "password2_$dirty",
				       type => 'password'));

    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell (__"Language");
    my $lingua_combo = IWL::Combo->new (name => 'lingua');
    $row->appendCell ($lingua_combo);
    my $linguas = $c->config->{linguas};
    foreach my $lingua (sort { $linguas->{$a} cmp $linguas->{$b} } 
			keys %$linguas) {
	my $value = $lingua;
	my $name = $linguas->{$lingua};
	$lingua_combo->appendOption ($name, $value);
    }

    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell ('&nbsp;');
    my $submit = IWL::Anchor->new (type => 'submit',
				   name => 'save',
				   value => __"Save");
    $row->appendCell ($submit);

    foreach my $row (@rows) {
	$table->appendBody ($row);
    }

    $form->applyState ($params);

    return $form->getContent;
}

sub __createChangeForm : Private {
    my ($self, $c, $email_address) = @_;

    my $params = IWL::Stash->new ($c->request->params);

    my $form = IWL::Form->new (action => '/account/save_personal', 
			       method => 'post',
			       name => 'personal_data');

    # FIXME: This is a nuisance.
    my $skin_js = IWL::Script->new;
    $form->appendChild ($skin_js);

    my $skin_dir = $IWLConfig{SKIN_DIR};

    $skin_js->appendScript ("var skin_dir = '$skin_dir'\n");

    unless ($params->getValues ('dirty')) {
	my $user = $c->model('BGTrainerDB::User')->find 
	    ($email_address,
	     { key => 'users_email_address' });

	foreach my $prop (qw (first_name last_name lingua)) {
	    my $val = $user->$prop;
	    $params->setValues ($prop => $user->$prop);
	}
    }

    unless ($params->getValues ('dirty')) {
	my $dirty = sprintf '%04x%04x', (int rand 0x10000), (int rand 0x10000);
	$params->setValues (dirty => $dirty);
    }

    my $dirty = $params->getValues ('dirty');
    $form->appendChild (IWL::Hidden->new (name => 'dirty',
					  value => $dirty));

    my $table = IWL::Table->new (cellspacing => 1,
				 cellpadding => 1);
    $form->appendChild ($table);

    my @rows;
    my $row;

    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell (__"First name");
    $row->appendCell (IWL::Input->new (name => 'first_name'));

    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell (__"Last name");
    $row->appendCell (IWL::Input->new (name => 'last_name'));

    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell (__"Language");
    my $lingua_combo = IWL::Combo->new (name => 'lingua');
    $row->appendCell ($lingua_combo);
    my $linguas = $c->config->{linguas};
    foreach my $lingua (sort { $linguas->{$a} cmp $linguas->{$b} } 
			keys %$linguas) {
	my $value = $lingua;
	my $name = $linguas->{$lingua};
	$lingua_combo->appendOption ($name, $value);
    }

    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell ('&nbsp;');
    my $submit = IWL::Input->new (type => 'submit',
				  name => 'save',
				  value => __"Save");
    $row->appendCell ($submit);

    foreach my $row (@rows) {
	$table->appendBody ($row);
    }

    $form->applyState ($params);

    return $form->getContent;
}

sub __createPasswordForm : Private {
    my ($self, $c) = @_;

    my $params = IWL::Stash->new ($c->request->params);

    my $form = IWL::Form->new (action => '/account/save_password', 
			       method => 'post',
			       name => 'password');

    # FIXME: This is a nuisance.
    my $skin_js = IWL::Script->new;
    $form->appendChild ($skin_js);

    my $skin_dir = $IWLConfig{SKIN_DIR};

    $skin_js->appendScript ("var skin_dir = '$skin_dir'\n");

    unless ($params->getValues ('dirty')) {
	my $dirty = sprintf '%04x%04x', (int rand 0x10000), (int rand 0x10000);
	$params->setValues (dirty => $dirty);
    }

    my $dirty = $params->getValues ('dirty');
    $form->appendChild (IWL::Hidden->new (name => 'dirty',
					  value => $dirty));

    my $table = IWL::Table->new (cellspacing => 1,
				 cellpadding => 1);
    $form->appendChild ($table);

    my @rows;
    my $row;

    # Prevent browsers from auto-filling the field.
    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell (__"Old password");
    $row->appendCell (IWL::Input->new (name => "old_password_$dirty",
				       type => 'password'));
    
    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell (__"Password");
    $row->appendCell (IWL::Input->new (name => "password_$dirty",
				       type => 'password'));
    
    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell (__"Repeat password");
    $row->appendCell (IWL::Input->new (name => "password2_$dirty",
				       type => 'password'));

    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell ('&nbsp;');
    my $submit = IWL::Input->new (type => 'submit',
				  name => 'save',
				  value => __"Save");

    $row->appendCell ($submit);

    foreach my $row (@rows) {
	$table->appendBody ($row);
    }

    $form->applyState ($params);

    return $form->getContent;
}

sub forgotten : Local {
    my ($self, $c) = @_;

    $c->stash->{template} = 'account/personal.tt2';

    my $params = IWL::Stash->new ($c->request->params);

    my $form = IWL::Form->new (action => '/account/forgotten_do', 
			       method => 'post',
			       name => 'forgotten');

    # FIXME: This is a nuisance.
    my $skin_js = IWL::Script->new;
    $form->appendChild ($skin_js);

    my $skin_dir = $IWLConfig{SKIN_DIR};

    $skin_js->appendScript ("var skin_dir = '$skin_dir'\n");

    my $table = IWL::Table->new (cellspacing => 1,
				 cellpadding => 1);
    $form->appendChild ($table);

    my @rows;
    my $row;

    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell (__"E-mail address");
    $row->appendCell (IWL::Input->new (name => 'email_address'));

    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell ('&nbsp;');
    my $submit = IWL::Input->new (type => 'submit',
				  name => 'save',
				  value => __"Save");

    $row->appendCell ($submit);

    foreach my $row (@rows) {
	$table->appendBody ($row);
    }

    $form->applyState ($params);

    $c->stash->{form} = $form->getContent;

    return 1;
}

sub forgotten_do : Local {
    my ($self, $c) = @_;

    my $params = IWL::Stash->new ($c->request->params);

    my $email_address = $params->getValues ('email_address');
    $email_address = normalize_email_address $email_address;
    unless ($email_address) {
	$c->stash->{error_msg} = __"Invalid e-mail address!";
	$c->detach ('forgotten');
	return 1;
    }

    my $user = $c->model('BGTrainerDB::User')->find
	($email_address,
	 {
	     key => 'users_email_address',
	 });
    unless ($user) {
	$c->stash->{error_msg} = __("The specified e-mail is not "
				    . "registered!");
	$c->detach ('forgotten');
    }

    # Generate a new random password;
    my @chars = ('0' .. '9', 'A' .. 'Z', 'a' .. 'z');
    my $length = 8 + int rand 6;
    my $password = '';
    for (1 .. $length) {
	$password .= $chars[int rand (1 + $#chars)];
    }
    
    my $result_set = $c->model('BGTrainerDB::User');
    my $schema = $result_set->result_source->schema;
    eval {
	$schema->txn_begin;
	$user->update ({password => sha1_hex $password});
    };

    if ($@) {
	$c->stash->{error_msg} = __"Internal error, please try again later!";
	$schema->txn_rollback;
	$c->detach ('create');
    } else {
	$schema->txn_commit;
    }
    
    my $data = __x(<<EOF, base => $c->request->base, password => $password);
Hi,

somebody, hopefully you, has requested to change your password
for the site {base}.

Your new password is: {password}

Yours sincerely,
BGTrainer
EOF

    my %mail = (
		to => $email_address,
		first_name => $user->first_name,
		last_name => $user->last_name,
		subject => __"Your new password",
		data => $data,
		from_domain => $c->config->{mail}->{from_domain},
		);

    unless (sendmail %mail) {
	$c->{stash}->{error_msg} = <<EOF;
Sorry, an error has occurred sending your mail.  Please try again later!
EOF
        $c->detach ('forgotten');
	return 1;
    }

    $c->stash->{template} = 'account/mailsent.tt2';
    $c->stash->{recipient} = $email_address;

    return 1;
}

sub email_address : Local {
    my ($self, $c) = @_;

    $c->stash->{template} = 'account/personal.tt2';

    my $params = IWL::Stash->new ($c->request->params);

    my $form = IWL::Form->new (action => '/account/email_address_do', 
			       method => 'post',
			       name => 'email_address');

    # FIXME: This is a nuisance.
    my $skin_js = IWL::Script->new;
    $form->appendChild ($skin_js);

    my $skin_dir = $IWLConfig{SKIN_DIR};

    $skin_js->appendScript ("var skin_dir = '$skin_dir'\n");

    my $table = IWL::Table->new (cellspacing => 1,
				 cellpadding => 1);
    $form->appendChild ($table);

    my @rows;
    my $row;

    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell (__"New E-mail address");
    $row->appendCell (IWL::Input->new (name => 'email_address'));

    unless ($params->getValues ('dirty')) {
	my $dirty = sprintf '%04x%04x', (int rand 0x10000), (int rand 0x10000);
	$params->setValues (dirty => $dirty);
    }

    my $dirty = $params->getValues ('dirty');
    $form->appendChild (IWL::Hidden->new (name => 'dirty',
					  value => $dirty));

    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell (__"Password");
    $row->appendCell (IWL::Input->new (name => "password_$dirty",
				       type => 'password'));

    push @rows, IWL::Table::Row->new;
    $row = $rows[-1];
    $row->appendTextCell ('&nbsp;');

    my $submit = IWL::Input->new (type => 'submit',
				  name => 'save',
				  value => __"Save");

    $row->appendCell ($submit);

    foreach my $row (@rows) {
	$table->appendBody ($row);
    }

    $form->applyState ($params);

    $c->stash->{form} = $form->getContent;

    return 1;
}

sub email_address_do : Local {
    my ($self, $c) = @_;

    my $params = IWL::Stash->new ($c->request->params);

    my $dirty = $params->getValues ('dirty');
    unless ($dirty) {
	$c->stash->{error_msg} = __"Internal error!";
	$c->detach ('email_address');
	return 1;
    }

    my $email_address = $params->getValues ('email_address');
    $email_address = normalize_email_address $email_address;
    unless ($email_address) {
	$c->stash->{error_msg} = __"Invalid e-mail address!";
	$c->detach ('email_address');
	return 1;
    }

    my $exists = $c->model('BGTrainerDB::User')->find
	($email_address,
	 {
	     key => 'users_email_address',
	 });
    if ($exists) {
	$c->stash->{error_msg} = __("The specified e-mail address is already "
				    . "registered!");
	$c->detach ('email_address');
    }

    my $password = $params->getValues ("password_$dirty");
    unless (defined $password && length $password) {
	$c->stash->{error_msg} = __("You must specify your password!");
	$c->detach ('email_address');
	return 1;
    }

    unless ($c->user->password eq sha1_hex $password) {
	$c->stash->{error_msg} = __("Invalid password!");
	$c->detach ('email_address');
	return 1;
    }

    my @gmtime = gmtime;
    my $timestamp = sprintf ("%04d-%02d-%02d %02d:%02d:%02d",
			     $gmtime[5] + 1900,
			     $gmtime[4] + 1,
			     $gmtime[3],
			     $gmtime[2], $gmtime[1], $gmtime[0]);

    my $request = {
		   timestamp => $timestamp,
		   email_address => $email_address,
		   user_id => $c->user->get_column ('id'),
		   };

    my $digest_string = $c->config->{secret};
    foreach my $key (sort keys %$request) {
	my $value = $request->{$key};
	next unless defined $value && length $value;
	$digest_string .= $request->{$key};
    }
    $request->{id} = sha1_hex $digest_string;

    my $result_set = $c->model('BGTrainerDB::Request');
    my $schema = $result_set->result_source->schema;
    eval {
	$schema->txn_begin;
	$c->model('BGTrainerDB::Request')->create($request);
    };

    if ($@) {
	$c->stash->{error_msg} = __"Internal error, please try again later!";
	$schema->txn_rollback;
	$c->detach ('create');
    } else {
	$schema->txn_commit;
    }
    
    my $link = $c->request->base;

    $link .= "account/confirm/$request->{id}";

    my $data = __x(<<EOF, base => $c->request->base, link => $link);
Hi,

please finish confirmation of your new mail address for {base} here:

  {link}

Please finish the confirmation within the next 72 hours.

Yours sincerely,
BGTrainer
EOF

    my $language = $c->user->lingua;
    $language =~ s/-.*//;

    my %mail = (
		to => $email_address,
		first_name => $c->user->first_name,
		last_name => $c->user->last_name,
		subject => __"Please confirm your new mail address!",
		data => $data,
		from_domain => $c->config->{mail}->{from_domain},
		language => $language,
		);

    unless (sendmail %mail) {
	$c->{stash}->{error_msg} = <<EOF;
Sorry, an error has occurred sending your mail.  Please try again later!
EOF
        $c->detach ('email_address');
	return 1;
    }

    $c->stash->{template} = 'account/mailsent.tt2';
    $c->stash->{recipient} = $email_address;

    return 1;
}

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
