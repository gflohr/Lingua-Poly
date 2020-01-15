#! /bin/false

package BGTrainerDB::Word;

use strict;

use base qw (DBIx::Class);

__PACKAGE__->load_components (qw (UTF8Columns Core));
__PACKAGE__->table ('words');
__PACKAGE__->add_columns (qw (word base_id frequency variant));
__PACKAGE__->utf8_columns (qw (word));
__PACKAGE__->set_primary_key (qw (word base_id));

__PACKAGE__->belongs_to (base_id => 'BGTrainerDB::BaseForm');

1;
