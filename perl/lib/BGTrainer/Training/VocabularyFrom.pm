#! /bin/false

package BGTrainer::Training::VocabularyFrom;

use strict;

use utf8;

use Locale::TextDomain qw (net.guido-flohr.bgtrainer);

sub new {
    my ($class, %args) = @_;

    my $name = __PACKAGE__;
    $name =~ s/.*:://;

    bless {
	__name => $name,
    }, $class;
}

sub getName {
    shift->{__name};
}

sub getWords {
    my ($self, $c, $number, $random) = @_;

    my $lingua = 'en';
    if ($c->user) {
	$lingua = $c->user->lingua || 'en';
    }
    $lingua =~ s/-.*//;

    my $order_by = $random ? 'RANDOM()' : 'frequency DESC';
    my @result = $c->model ('BGTrainerDB::BaseForm')->search_literal
	(
	 "EXISTS (SELECT * FROM translation_$lingua "
	 . "WHERE translation_$lingua.base_id = me.id)",
     {
	 page => 0,
	 rows => $number,
	 order_by => [ $order_by ],
	 distinct => 0,
	 columns => [ qw (id word) ],
     }
	 );
    
    my @words = map { $_->id } @result;

    return \@words;
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
