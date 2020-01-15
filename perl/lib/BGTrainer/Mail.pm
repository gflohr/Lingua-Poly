#! /bin/false
# vim: set autoindent shiftwidth=4 tabstop=4:
# (w) Guido Flohr

package BGTrainer::Mail;

use strict;

use constant DEBUG => 1,

require Exporter;
use vars qw (@ISA @EXPORT @EXPORT_OK);

@ISA = qw (Exporter);
@EXPORT = ();
@EXPORT_OK = qw (lines2paragraphs format_paragraph format_body
				 sendmail normalize_email_address);

use utf8;

use Locale::Messages qw (turn_utf_8_on);
use Locale::TextDomain qw (net.guido-flohr.bgtrainer);
use MIME::Entity;

sub lines2paragraphs {
	my ($text, $flowed) = @_;

	turn_utf_8_on ($text);

	# This will silently add a trailing new line.
	my @lines = split /\r?\n/, $text;

	my @unquoted;

	foreach my $line (@lines) {
		my $quote_level = 0;
		my $quote = '';
		my $is_flowed = 0;

		if ($flowed) {
			my $last = substr $line, -1;
			my $first = substr $line, 0;

			if ($last && ' ' eq $last) {
				$is_flowed = $line ne '-- ';
			}

			# Space stuffed?
			$line =~ s/^ //;
		}

		if ($line =~ s/^([>:](?:[>: ])*)//) {
			$quote = $1;
			$quote_level = ($quote =~ y/>:/>:/);
		}

		my $length = length $line;

		push @unquoted, {
			line => $line,
			quote => $quote,
			quote_level => $quote_level,
			flowed => $is_flowed,
			length => $length,
		}
	}

	my @paragraphs;

	while (@unquoted) {
		my $line = shift @unquoted;

		if ($line->{flowed}) {
			while (@unquoted) {
				my $next_line = shift @unquoted;
				if ($next_line ->{quote_level} == $line->{quote_level} &&
					$next_line->{quote} eq $line->{quote}) {
					$line->{line} .= $next_line->{line};
					$line->{length} += $next_line->{length};
					last unless $next_line->{flowed};
				} else {
					unshift @unquoted, $next_line;
					last;
				}
			}
		}

		push @paragraphs, $line;
	}

	return \@paragraphs;
}

sub escape_linefeed {
	my ($line, $max_length) = @_;

	return $line . "\n";
}

sub format_paragraph {
	my ($paragraph, $flowed_length, $unflowed_length, $for_mail) = @_;

	my $max_length = $flowed_length;

	$paragraph =~ s/ +$//;

	unless (length $paragraph) {
		return "\n";
	}

	my @chunks;
	while (length $paragraph) {
		if ($paragraph =~ s/^([^ ]+)//) {
			push @chunks, $1;
		} else {
			$paragraph =~ s/^( +)//;
			push @chunks, $1;
		}
	}

	my @lines = ();
	my $first_chunk = shift @chunks;
	$first_chunk = " $first_chunk" if $for_mail &&
		$first_chunk =~ /^( |>|From)/;
	my $current_line = $first_chunk;
	while (@chunks) {
		my $chunk = shift @chunks;
		my $is_space = $chunk !~ /[^ ]/;
		my $has_more = @chunks;
		my $trailing_space = ($is_space || !$has_more) ? '' : ' ';

		my $length = (length $current_line) + (length $chunk) + (length $trailing_space);
		if ($length >= $max_length) {
			$current_line =~ s/ *$//;
			push @lines, $current_line if $current_line =~ /[^ ]/;
			$chunk =~ s/^( |>|From)/ $1/ if $for_mail;

			$current_line = $is_space ? '' : $chunk;
		} else {
			$current_line .= $chunk;
		}
	}
	push @lines, $current_line if $current_line =~ /[^ ]/;

	@lines = map { s/( *)$/ /; $_ } @lines;
	$lines[-1] =~ s/ $// if @lines;

	my $result = join "\n", @lines;
	$result .= "\n";

	Encode::_utf8_off ($result);

	return $result;
}

sub format_body {
	my $raw = shift;

	my @paragraphs = split /\n/, $raw;

	my $retval = '';
	foreach my $paragraph (@paragraphs) {
		$retval .= format_paragraph ($paragraph, 72, 997, 1);
	}
	return $retval;
}

sub sendmail {
    my (%args) = @_;
    
    require Net::SMTP;

    my $subject = $args{subject} || __"Message from BGTrainer";
    my $data = format_body $args{data};

	my $verp = $args{to};
	$verp =~ s/\@/=/;
	my $sender = "bgtrainer-bounces+$verp\@$args{from_domain}";
	my $mail_from = "bgtrainer-bounces+$verp\@$args{from_domain}";
	
	my $from = "BGtrainer <bgtrainer\@$args{from_domain}>";

	my @headers = 
		(From => $from,
		 To => $args{to},
		 Subject => $subject,
		 Sender => $sender,
		 'Precedence:' => 'bulk',
		 'Errors-To:' => $sender,
		 'Content-Type' => 'text/plain; format=flowed; charset=utf-8',
		 'Content-Language' => $args{language},
		 'Content-Transfer-Encoding' => 'Quoted-Printable',
		 Data => $data);

	my $entity = MIME::Entity->build (@headers);
	$entity->smtpsend (MailFrom => $mail_from,
					   To => $args{to},
					   Debug => DEBUG) or return;

    return 1;
}

sub normalize_email_address {
    my ($addr) = @_;

    $addr = lc $addr;
    $addr =~ s/ //g;

    require Email::Valid;

    my $valid = Email::Valid->address (-address => $addr,
				       -mxcheck => 1,
				       -tldcheck => 1,
				       -fudge => 0,
				       -fqdn => 1,
				       );
    return unless $valid;

    return $valid;
}

1;

__END__

Local Variables:
mode: perl
perl-indent-level: 4
perl-continued-statement-offset: 4
perl-continued-brace-offset: 0
perl-brace-offset: -4
perl-brace-imaginary-offset: 0
perl-label-offset: -4
tab-width: 4
End:
