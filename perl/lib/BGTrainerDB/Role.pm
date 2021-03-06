#! /bin/false

package BGTrainerDB::Role;

use strict;

use base qw (DBIx::Class);

__PACKAGE__->load_components (qw (PK::Auto UTF8Columns Core));
__PACKAGE__->table ('roles');
__PACKAGE__->add_columns (qw (id rolename));
__PACKAGE__->utf8_columns (qw (rolename));
__PACKAGE__->set_primary_key ('id');
__PACKAGE__->add_unique_constraint ([qw (rolename)]);

__PACKAGE__->has_many(map_user_role => 'BGTrainerDB::UserRole', 'role_id');

1;
