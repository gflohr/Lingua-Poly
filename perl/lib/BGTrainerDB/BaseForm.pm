#! /bin/false

package BGTrainerDB::BaseForm;

use strict;

use base qw (DBIx::Class);

__PACKAGE__->load_components (qw (PK::Auto UTF8Columns Core));
__PACKAGE__->table ('baseforms');
__PACKAGE__->add_columns (qw (id word frequency category inflections
			      emphasis additional peer));
__PACKAGE__->utf8_columns (qw (word)); 
__PACKAGE__->set_primary_key ('id');

__PACKAGE__->belongs_to (category => 'BGTrainerDB::Category');

1;
