#! /bin/false

package BGTrainer::Case;

use strict;

use utf8;

use vars qw (@EXPORT_OK);

use base qw (Exporter);

@EXPORT_OK = qw (bg_tolower bg_toupper bg_lower bg_upper);

my %lower2upper = (
	     'а' => 'А',
	     'б' => 'Б',
	     'в' => 'В',
	     'г' => 'Г',
	     'е' => 'Е',
	     'д' => 'Д',
	     'ж' => 'Ж',
	     'з' => 'З',
	     'и' => 'И',
	     'й' => 'Й',
	     'к' => 'К',
	     'л' => 'Л',
	     'м' => 'М',
	     'н' => 'Н',
	     'о' => 'О',
	     'п' => 'П',
	     'р' => 'Р',
	     'с' => 'С',
	     'т' => 'Т',
	     'у' => 'У',
	     'ф' => 'Ф',
	     'х' => 'Х',
	     'ц' => 'Ц',
	     'ч' => 'Ч',
	     'ш' => 'Ш',
	     'щ' => 'Щ',
	     'ъ' => 'Ъ',
	     'ь' => 'Ь',
	     'ю' => 'Ю',
	     'я' => 'Я',
	     );
my %upper2lower = reverse %lower2upper;

sub bg_tolower {
	my ($string) = @_;

	$string = lc $string;
	$string =~ s/(.)/$upper2lower{$1} || $1/ge;	

	return $string;
}

sub bg_toupper {
	my ($string) = @_;

	$string = lc $string;
	$string =~ s/(.)/$lower2upper{$1} || $1/ge;	

	return $string;
}

sub bg_upper { keys %upper2lower };
sub bg_lower { keys %lower2upper };

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
