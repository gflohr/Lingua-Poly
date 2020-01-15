#! /bin/false

package BGTrainer::Util;

use strict;

use utf8;

use vars qw (@EXPORT_OK);

use base qw (Exporter);

@EXPORT_OK = qw (bg_wordsplit bg_cleanwordsplit escape_html bg_emphasize
		 bg_word bg_count_syllables split_pg_array clean_params
		 join_pg_array sendmail normalize_email_address
		 bg_standout);

use BGTrainer::Case;
use Locale::Messages qw (turn_utf_8_on);

my $strict_word_chars = join '', (BGTrainer::Case::bg_upper(), 
				  BGTrainer::Case::bg_lower());
my $word_chars = "-$strict_word_chars";
my $word_re = qr /[$word_chars]+/o;
my $non_word_re = qr /[^$word_chars]+/o;
my $non_strict_word_re = qr /[^$strict_word_chars]/o;
my $pattern = qr /^($word_re)($non_word_re)/so;

sub bg_word {
    my ($word, $strict) = @_;

    if ($word =~ /$non_word_re/) {
	return;
    }

    if ($strict && '-' eq $word) {
	return;
    }

    return 1;
}

sub bg_wordsplit {
    my ($sentence, $keep_other) = @_;

    return [] unless defined $sentence && length $sentence;

    my @words;

    $sentence =~ s/^$non_word_re//;
    return [] unless length $sentence;

    $sentence .= ' ';
    while (length $sentence) {
	$sentence =~ s/^$pattern//;
	my $word = $1;
	my $rest = $2;

	if (!$keep_other) {
	    $word =~ s/^[\x00-\xff]+//;
	    $word =~ s/[\x00-\xff]+$//;
	    
	    next unless length $word;
	    push @words, $word;
	} else {
	    push @words, $word, $rest;
	}
    }

    return \@words;
}

sub bg_cleanwordsplit {
    my ($sentence, $keep_other, $keep_comp) = @_;

    my $words = bg_wordsplit $sentence, $keep_other or return;

    my @result;
    foreach my $word (@$words) {
	if ($word =~ s/^([Нн][Аа][Йй]|[Пп][Оо])(-)//) {
	    if ($keep_comp) {
		push @result, $1, $2, $word;
	    } else {
		push @result, $word;
	    }
	} else {
	    push @result, $word;
	}
    }

    return \@result;
}

sub bg_standout {
    my ($sentence, $callback) = @_;

    $sentence =~ s{~}{&$callback ('~')}ge;
    $sentence =~ s
        {([$strict_word_chars]+(?:[$word_chars]*)?)}
        {&$callback ($1)}gex;

    return $sentence;
}

sub escape_html {
    my ($string) = @_;

    return unless defined $string;

    $string =~ s/&/&amp;/g;
    $string =~ s/</&lt;/g;
    $string =~ s/>/&gt;/g;
    $string =~ s/\"/&quot;/g; #" St. Emacs
    $string =~ s/\'/&\#39;/g; #'

    return $string;
}

sub bg_count_syllables {
    my ($string) = @_;

    my $syllables = $string =~ tr/[АаЕеИиОоУуЪъЮюЯя]/[АаЕеИиОоУуЪъЮюЯя]/;
    $syllables = 1 if $syllables < 1;

    return $syllables;
}

sub bg_emphasize {
    my ($string, $callback, @stresses) = @_;

    turn_utf_8_on $string;

    my $syllables = $string =~ tr/[АаЕеИиОоУуЪъЮюЯя]/[АаЕеИиОоУуЪъЮюЯя]/;
    return $string if $syllables <= 1;

    my $negative = 0;
    my %stresses = map { ++$negative if $_ < 0; $_ => 1 } @stresses;

    if ($negative) {
	@stresses = map {
	    if ($_ < 0) {
		delete $stresses{$_};
		my $value = $syllables + 1 + $_;
		$stresses{$value} = 1;
		$value;
	    } else {
		$_;
	    }
	} @stresses;
    }

    my $syllable = 1;    
    $string =~ s
	/
	([АаЕеИиОоУуЪъЮюЯя])
	/
	$stresses{$syllable++} ? &$callback ($1) : $1;
	/ogex;

    return $string;
}

sub split_pg_array {
    my $string = shift;

    return unless defined $string;

    $string = substr $string, 1, (length $string) - 2;

    return split / *, */, $string;
}

sub join_pg_array {
    my @items = @_;

    # We sort the items, so that update_or_create still works.
    my $string = join ',', sort grep { defined $_ && length $_ } @items;
    
    return '{' . $string . '}';
}

sub clean_params {
    my ($params, $escape) = shift;

    foreach my $key ($params->keys) {
	my @values = $params->getValues ($key);
	my @new_values;
	foreach my $value (@values) {
	    $value = '' unless defined $value;
	    $value =~ s/^\s+//;
	    $value =~ s/\s+$//;
	    $value = escape_html $value if $escape;
	    turn_utf_8_on $value;
	    push @new_values, $value;
	}
	$params->setValues ($key => @values);
    }

    return 1;
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
