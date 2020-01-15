#! /bin/false

package BGTrainerDB::UserRole;

use strict;

use base qw (DBIx::Class);

__PACKAGE__->load_components (qw (PK::Auto Core));
__PACKAGE__->table ('user_role');
__PACKAGE__->add_columns (qw (user_id role_id));
__PACKAGE__->set_primary_key (qw (user_id role_id));

__PACKAGE__->belongs_to(user => 'BGTrainerDB::User', 'user_id');
__PACKAGE__->belongs_to(role => 'BGTrainerDB::Role', 'role_id');

1;
