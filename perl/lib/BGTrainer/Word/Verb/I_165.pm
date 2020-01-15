#! /bin/false

package BGTrainer::Word::Verb::I_165;

use strict;

use utf8;

use base qw (BGTrainer::Word::Verb::I_159);

sub new {
    my ($class, $word, %args) = @_;
    
    my $self = $class->SUPER::new ($word, %args);

    return $self;
}

sub past_aorist {
    return (undef) x 6;
}

sub past_active_aorist_participle {
    return (undef) x 9;
}

sub past_passive_participle {
    return (undef) x 9;
}

sub renarrative_passive {
    return (undef) x 8;
}

1;

#Local Variables:
#mode: perl
#perl-indent-level: 4
#perl-continued-statement-offset: 4
#perl-continued-brace-offset: 0
#perl-brace-offset: -4
#perl-brace-imaginary-offset: 0
#perl-label-offset: -4
#cperl-indent-level: 4
#cperl-continued-statement-offset: 2
#tab-width: 8
#coding: utf-8
#End:
