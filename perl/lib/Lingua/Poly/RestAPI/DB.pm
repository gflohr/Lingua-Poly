#! /bin/false
#
# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018 Guido Flohr <guido.flohr@Lingua::Poly::API.com>
#			   All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package Lingua::Poly::RestAPI::DB;

use strict;

use DBI;

use base 'Lingua::Poly::RestAPI::Logger';

use constant STATEMENTS => {

	DELETE_SESSION => <<EOF,
DELETE FROM sessions
  WHERE sid = ?
EOF
	DELETE_SESSION_STALE => <<EOF,
DELETE FROM sessions
  WHERE EXTRACT(EPOCH FROM(NOW() - last_seen)) > ?
EOF
	INSERT_SESSION => <<EOF,
INSERT INTO sessions(sid, user_id, footprint)
  VALUES(?, ?, ?)
EOF
	SELECT_SESSION_INFO => <<EOF,
SELECT user_id, EXTRACT(EPOCH FROM(NOW() - last_seen)), footprint FROM sessions
  WHERE sid = ?
EOF
	SELECT_USER_BY_ID => <<EOF,
SELECT email, password FROM users WHERE id = ?
EOF
	SELECT_USER_BY_EMAIL => <<EOF,
SELECT id, password FROM users WHERE email = ?
EOF
	UPDATE_SESSION => <<EOF,
UPDATE sessions
   SET last_seen = NOW()
 WHERE sid = ?
EOF
};

sub realm { 'db' };

sub new {
	my ($class, $app) = @_;

	my $self = {
		__app => $app
	};
	bless $self, $class;

	my $config = $app->config->{database};

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
	my ($self, $statement, @args) = @_;

	my $sth = $self->execute($statement, @args) or return;

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

