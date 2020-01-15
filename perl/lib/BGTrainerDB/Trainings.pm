#! /bin/false

package BGTrainerDB::Trainings;

use strict;

use base qw (DBIx::Class);

__PACKAGE__->load_components (qw (PK::Auto UTF8Columns Core));
__PACKAGE__->table ('trainings');
__PACKAGE__->add_columns (qw (id user_id type words last_use
                             level0 level1 level2 level3 level4
			     level5 level6 level7 level8 level9
                             ));
# This is currently a lie, the primary key is really user_id and type.
__PACKAGE__->set_primary_key ('id');

__PACKAGE__->belongs_to (user_id => 'BGTrainerDB::User');
__PACKAGE__->has_many (data => 'BGTrainerDB::TrainingData', 'id');

1;
