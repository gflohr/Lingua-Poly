#! /bin/false

package BGTrainerDB;

use strict;

use base qw (DBIx::Class::Schema);

__PACKAGE__->load_classes ({
    BGTrainerDB => [qw (BaseForm User UserRole Role Category Word Request
    			Trainings TrainingData
                        Translation_EN Translation_DE
                       )],
});

1;
