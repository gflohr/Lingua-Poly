#! /bin/false

package BGTrainerDB::Category;

use strict;

use base qw(DBIx::Class);

__PACKAGE__->load_components(qw(PK::Auto UTF8Columns Core));
__PACKAGE__->table('categories');
__PACKAGE__->add_columns(qw(id name long_name));
__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(baseforms => 'BGTrainerDB::BaseForm', 'category');

1;
