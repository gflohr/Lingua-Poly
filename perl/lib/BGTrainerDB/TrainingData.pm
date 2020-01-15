#! /bin/false

package BGTrainerDB::TrainingData;

use strict;

use base qw (DBIx::Class);

__PACKAGE__->load_components (qw (PK::Auto UTF8Columns Core));
__PACKAGE__->table ('training_data');
__PACKAGE__->add_columns (qw (id word level));
__PACKAGE__->set_primary_key ('id');

__PACKAGE__->belongs_to (id => 'BGTrainerDB::Trainings', 
			 { 'foreign.id' => 'self.id' } );

1;
