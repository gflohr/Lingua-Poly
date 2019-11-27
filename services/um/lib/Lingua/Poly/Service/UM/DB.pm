#! /bin/false
#
# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018-2019 Guido Flohr <guido.flohr@Lingua::Poly::API.com>
#			   All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package Lingua::Poly::Service::UM::DB;

use strict;

use Mojo::Base qw(Lingua::Poly::Service::UM::Logging);

use DBI;

use Lingua::Poly::Service::UM::Util qw(empty);

use constant STATEMENTS => {

	DELETE_SESSION => <<EOF,
DELETE FROM sessions
  WHERE sid = ?
EOF
	DELETE_SESSION_STALE => <<EOF,
DELETE FROM sessions
  WHERE EXTRACT(EPOCH FROM(NOW() - last_seen)) > ?
EOF
	SELECT_SESSION_INFO => <<EOF,
SELECT user_id, EXTRACT(EPOCH FROM(NOW() - last_seen)), fingerprint FROM sessions
  WHERE sid = ?
EOF
	DELETE_TOKEN_STALE => <<EOF,
DELETE FROM tokens
  WHERE EXTRACT(EPOCH FROM(NOW() - created)) > ?
EOF
	INSERT_TOKEN => <<EOF,
INSERT INTO tokens(token, purpose, user_id)
  VALUES(?, ?, ?)
EOF
	UPDATE_TOKEN => <<EOF,
UPDATE tokens SET created = NOW()
  WHERE tokens.purpose = ?
    AND tokens.user_id = (SELECT id FROM users WHERE email = ? AND NOT confirmed)
EOF
	DELETE_TOKEN => <<EOF,
DELETE FROM tokens WHERE token = ?
EOF
	SELECT_TOKEN => <<EOF,
SELECT u.id, u.username, u.email FROM tokens t, users u
  WHERE t.purpose = ?
    AND t.token = ?
	AND t.user_id = u.id
	AND NOT u.confirmed
EOF
	SELECT_TOKEN_BY_PURPOSE => <<EOF,
SELECT t.token FROM tokens t, users u
  WHERE t.purpose = ?
    AND u.email = ?
    AND t.user_id = u.id
	AND NOT u.confirmed
EOF
	INSERT_USER => <<EOF,
INSERT INTO users(email, password) VALUES(?, ?)
EOF
	DELETE_USER_STALE => <<EOF,
DELETE FROM users u
  USING tokens t
  WHERE NOT u.confirmed
    AND u.id = t.user_id
	AND EXTRACT(EPOCH FROM(NOW() - t.created)) > ?
EOF
	SELECT_USER_BY_ID => <<EOF,
SELECT id, username, email, password, confirmed FROM users WHERE id = ?
EOF
	SELECT_USER_BY_USERNAME => <<EOF,
SELECT id, username, email, password, confirmed FROM users WHERE username = ?
EOF
	SELECT_USER_BY_EMAIL => <<EOF,
SELECT id, username, email, password, confirmed FROM users WHERE email = ?
EOF
	UPDATE_USER_ACTIVATE => <<EOF,
UPDATE users
   SET confirmed = 't'
 WHERE id = ?
EOF
	UPDATE_SESSION => <<EOF,
UPDATE sessions
   SET last_seen = NOW()
 WHERE sid = ?
EOF
};

sub new {
	my ($class, %args) = @_;

	my $self = bless {
		_logger => $args{logger}->context('[db]'),
	}, $class;

	my $config = $args{configuration};

	my $dbname = $config->{dbname};
	$self->debug("connecting to database '$dbname' as user '$config->{user}'.");
	my $dbh = eval {
		DBI->connect("dbi:Pg:dbname=$dbname",
						$config->{user}, $config->{pass},
						{
							RaiseError => 1,
							AutoCommit => 0,
						})
	};
	$self->fatal($@) if $@;

	while(my ($name, $sql) =  each %{STATEMENTS()}) {
		$self->debug("Preparing statement $name.");
		$self->{__sth}->{$name} = $dbh->prepare($sql);
	}

	$self->{__dbh} = $dbh;

	return $self;
}

sub app {
	shift->{__app};
}

sub commit {
	shift->{__dbh}->commit;
}

sub rollback {
	shift->{__dbh}->rollback;
}

sub lastInsertId {
	my ($self, $table) = @_;
	shift->{__dbh}->last_insert_id(undef, undef, $table);
}

sub finalize {
	my ($self) = @_;

	if ($self->{__dbh}->{ActiveKids}) {
		$self->{__dbh}->rollback;
	}

	return $self;
}

sub execute {
	my ($self, $statement, @args) = @_;

	my $sth = $self->getIterator($statement, @args);
	$sth->finish;

	return $self;
}

sub getIterator {
	my ($self, $statement, @args) = @_;

	my $sth = $self->{__sth}->{$statement}
		or $self->fatal("Undefined SQL statement '$statement'.");

	if (1) {
		my $sql = STATEMENTS()->{$statement};
		my @params = @args;
		$sql =~ s/\?/$self->{__dbh}->quote(shift @params)/ge;
		$self->debug("Execute $statement:\n" . $sql);
	}
	$sth->execute(@args);
	$self->debug("Statement $statement finished.");

	return $sth;
}

sub getRow {
	my ($self, $statement, @args) = @_;

	my $sth = $self->getIterator($statement, @args) or return;

	my @row = $sth->fetchrow_array;

	return if !@row;

	return wantarray ? @row : $row[0];
}

sub transaction {
	my ($self, @statements) = @_;

	foreach my $spec (@statements) {
		my ($statement, @args) = @$spec;
		if (!$self->execute($statement, @args)) {
			$self->{__dbh}->rollback;
			return;
		}
	}

	$self->{__dbh}->commit;

	return $self;
}

sub statement {
	my ($self, $sql, @args) = @_;

	my $dbh = $self->{__dbh};

	if (1) {
		my @quoted_args = map { $dbh->quote($_) } @args;
		my $pretty_sql = $sql;
		$pretty_sql =~ s/\?/shift @quoted_args/ge;
		$pretty_sql =~ s/\n/ /g;
		$pretty_sql =~ s/  +/ /g;
		$self->debug("Executing one shot statement:\n$pretty_sql");
	}

	my $sth = $dbh->prepare($sql);

	$sth->execute(@args);

	return $sth;
}

1;

