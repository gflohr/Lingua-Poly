#! /bin/false

package BGTrainer::Word;

use strict;

use utf8;

use BGTrainer::Util qw (bg_emphasize bg_count_syllables);
use Locale::TextDomain qw (net.guido-flohr.bgtrainer);

sub new {
    my ($class, $word, %args) = @_;

    $args{stresses} = [] unless $args{stresses};
    my @stresses = @{$args{stresses}};

    foreach my $stress (@stresses) {
	if ($stress < 0) {
	    my $syllables = bg_count_syllables $word;
	    @stresses = map { $_ < 0 ? $syllables + 1 + $_ : $_ } @stresses;
	}
    }

    $args{additional} = [] unless $args{additional};
    my %additional = map { $_ => 1 } @{$args{additional}};

    bless {
	_word => $word,
	_stresses => [@stresses],
	_additional => \%additional,
    }, $class;
}

sub inflect {
    my ($self, $tense) = @_;

    return $self->{_word} unless $tense;

    return $self->$tense;
}

sub setEmphasizer {
    my ($self, $callback) = @_;

    $self->{_emphasizer} = $callback;

    return $self;
}

sub _emphasize {
    my ($self, $word, @stresses) = @_;

    @stresses = @{$self->{_stresses}} unless @stresses;

    return $word unless $self->{_emphasizer};

    return bg_emphasize $word, $self->{_emphasizer}, @stresses;
}

sub features {
    return [];
}

sub base_inflections {
    return qw (__dummy);
}

sub __dummy {
    my ($self) = @_;

    return $self->_emphasize ($self->{_word});
}

sub feature {
    my ($self, $type) = @_;

    my $method_name = ucfirst lc $type;
    $method_name =~ s/_(.)/uc $1/gex;
    $method_name = "_getFeature$method_name";

    if ($self->can ($method_name)) {
	return $self->$method_name;
    } else {
	return __x("Unknown feature '{feature}'.",
		   feature => $type);
    }
}

sub describeVariations {
    return [];
}

sub describeWord {
    return '';
}

sub getSubTypes {
    my $class = shift;

    my $filename = $class;
    $filename =~ s,::,/,g;
    $filename .= '.pm';

    my $path = $INC{$filename};
    return () unless $path;

    $path =~ s,\.pm$,,;

    local *DIR;
    opendir DIR, $path or return ();

    require Roman;

    sub by_roman {
	my (@aparts) = split /_/, $a;
	my (@bparts) = split /_/, $b;
	
	for (my $i = 0; $i < @aparts; ++$i) {
	    my $apart = $aparts[$i];
	    my $bpart = $bparts[$i];
	    
	    return 1 unless defined $bpart;
	    next if $apart eq $bpart;
	    
	    if (Roman::isroman ($apart) && Roman::isroman ($bpart)) {
		my $anum = Roman::arabic ($apart);
		my $bnum = Roman::arabic ($bpart);

		return $anum <=> $bnum;
	    } elsif ($apart =~ /^[0-9]+/
		     && $bpart =~ /^([0-9]+)/) {
		my $bnum = $1;
		$apart =~ /^([0-9]+)/;
		my $anum = $1;
		return $anum <=> $bnum;
	    }
	}
	$a cmp $b;
    }

    my @sub_classes = 
	sort by_roman map { 
	    s/\.pm$//; $_; 
	} grep {
	    /\.pm$/;
	} readdir DIR;
    
    return @sub_classes;
}

sub longTable {
    return;
}

1;
