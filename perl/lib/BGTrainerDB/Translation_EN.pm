#! /bin/false

package BGTrainerDB::Translation_EN;

use strict;

use base qw (DBIx::Class);

__PACKAGE__->load_components (qw (PK::Auto UTF8Columns Core));
__PACKAGE__->table ('translation_en');
__PACKAGE__->add_columns (qw (base_id translation_id comment translation));
__PACKAGE__->utf8_columns (qw (comment translation));
__PACKAGE__->set_primary_key (qw (base_id translation_id));

__PACKAGE__->belongs_to (base_id => 'BGTrainerDB::BaseForm');

1;
