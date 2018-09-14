SET client_encoding = 'UTF8';

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL
);
INSERT INTO users(id, email, password) 
  SELECT 0, 'admin', '{SHA512}c7ad44cbad762a5da0a452f9e854fdc1e0e7a52a38015f23f3eab1d80b931dd472634dfac71cd34ebc35d16ab7fb8a90c81f975113d6c7538dc69dd8de9077ec='
  WHERE NOT EXISTS (
    SELECT 1 FROM users WHERE id = 0);

CREATE TABLE IF NOT EXISTS groups (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);
INSERT INTO groups(id, name) 
  SELECT 0, 'admin'
  WHERE NOT EXISTS (
    SELECT 1 FROM groups WHERE id = 0);

CREATE TABLE IF NOT EXISTS user_groups (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    group_id INTEGER REFERENCES groups(id) ON DELETE CASCADE,
    UNIQUE(user_id, group_id)
);
INSERT INTO user_groups (user_id, group_id)
  SELECT 0, 0
  WHERE NOT EXISTS  (
    SELECT 1 FROM user_groups  WHERE user_id = 0 AND group_id = 0);

CREATE TABLE IF NOT EXISTS sessions (
    id SERIAL PRIMARY KEY,
    sid CHAR(128) NOT NULL UNIQUE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    footprint TEXT,
    last_seen TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

