#! /bin/false

package BGTrainerDB::Request;

use strict;

use base qw (DBIx::Class);

__PACKAGE__->load_components (qw (PK::Auto UTF8Columns Core));
__PACKAGE__->table ('requests');
__PACKAGE__->add_columns (qw (id email_address password
			      first_name last_name lingua timestamp
			      user_id));
__PACKAGE__->utf8_columns (qw (password first_name last_name));
__PACKAGE__->set_primary_key ('id');

1;
