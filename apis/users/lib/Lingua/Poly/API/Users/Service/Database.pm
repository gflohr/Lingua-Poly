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

package Lingua::Poly::API::Users::Service::Database;

use strict;

use Moose;
use namespace::autoclean;

use DBI;

use Lingua::Poly::API::Users::Util qw(empty);

use base qw(Lingua::Poly::API::Users::Logging);

has configuration => (is => 'ro');
has logger => (is => 'ro');
has preparer => (is => 'ro');
has dbh => (is => 'rw', init_arg => undef);
has dirty => (is => 'rw', default => undef);

sub BUILD {
	my ($self) = @_;
	my $config = $self->configuration->{database};

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

	$self->dbh($dbh);

	return $self;
}

sub commit {
	shift->dbh->commit;
}

sub rollback {
	shift->dbh->rollback;
}

sub lastInsertId {
	my ($self, $table) = @_;
	shift->dbh->last_insert_id(undef, undef, $table);
}

sub finalize {
	my ($self) = @_;

	if ($self->dbh->{ActiveKids}) {
		$self->dbh->rollback;
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

	my ($sql, $sth) = $self->preparer->get($statement);

	if ($statement !~ /^SELECT_/) {
		$self->dirty(1);
	}

	if (1) {
		my @params = @args;
		$sql =~ s/\?/$self->dbh->quote(shift @params)/ge;
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
			$self->dbh->rollback;
			return;
		}
	}

	$self->dbh->commit;
	$self->dirty(undef);

	return $self;
}

__PACKAGE__->meta->make_immutable;

1;

