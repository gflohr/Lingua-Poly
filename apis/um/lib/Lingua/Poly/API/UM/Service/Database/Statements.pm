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

package Lingua::Poly::API::UM::Service::Database::Statements;

use strict;


sub new {
	bless {
		INSERT_SESSION => <<EOF,
INSERT INTO sessions(sid, fingerprint)
  VALUES(?, ?)
EOF
		DELETE_SESSION => <<EOF,
DELETE FROM sessions
  WHERE sid = ?
EOF
		DELETE_SESSION_STALE => <<EOF,
DELETE FROM sessions
  WHERE EXTRACT(EPOCH FROM(NOW() - last_seen)) > ?
EOF
		SELECT_SESSION => <<EOF,
SELECT user_id FROM sessions
  WHERE sid = ?
    AND fingerprint = ?
EOF
		UPDATE_SESSION => <<EOF,
UPDATE sessions
   SET last_seen = NOW()
 WHERE sid = ?
EOF
		UPDATE_SESSION_SID => <<EOF,
UPDATE sessions
   SET sid = ?, last_seen = NOW()
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
SELECT username, email, confirmed FROM users WHERE id = ?
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
	}, shift;
};

1;

