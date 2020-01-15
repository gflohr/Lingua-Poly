#! /bin/false

package BGTrainerDB::User;

use strict;

use base qw (DBIx::Class);

__PACKAGE__->load_components (qw (PK::Auto UTF8Columns Core));
__PACKAGE__->table ('users');
__PACKAGE__->add_columns (qw (id email_address password
			      first_name last_name lingua last_seen));
__PACKAGE__->utf8_columns (qw (password first_name last_name));
__PACKAGE__->set_primary_key ('id');
__PACKAGE__->add_unique_constraint ([qw (email_address)]);

__PACKAGE__->has_many(map_user_role => 'BGTrainerDB::UserRole', 'user_id');

1;
