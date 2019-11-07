SET client_encoding = 'UTF8';
CREATE EXTENSION IF NOT EXISTS citext;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email CITEXT NOT NULL UNIQUE,
    username CITEXT UNIQUE,
    password TEXT NOT NULL,
    confirmed BOOLEAN NOT NULL DEFAULT 'f'
);
INSERT INTO users(id, email, username, password) 
  SELECT 0, 'placeholder@example.com', 'admin', '{SHA512}c7ad44cbad762a5da0a452f9e854fdc1e0e7a52a38015f23f3eab1d80b931dd472634dfac71cd34ebc35d16ab7fb8a90c81f975113d6c7538dc69dd8de9077ec='
  WHERE NOT EXISTS (
    SELECT 1 FROM users WHERE id = 0);

CREATE TABLE groups (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);
INSERT INTO groups(id, name) 
  SELECT 0, 'admin'
  WHERE NOT EXISTS (
    SELECT 1 FROM groups WHERE id = 0);

CREATE TABLE user_groups (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    group_id INTEGER REFERENCES groups(id) ON DELETE CASCADE,
    UNIQUE(user_id, group_id)
);
INSERT INTO user_groups (user_id, group_id)
  SELECT 0, 0
  WHERE NOT EXISTS  (
    SELECT 1 FROM user_groups  WHERE user_id = 0 AND group_id = 0);

CREATE TABLE sessions (
    id SERIAL PRIMARY KEY,
    sid TEXT NOT NULL UNIQUE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    footprint TEXT,
    last_seen TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE registrations (
    id SERIAL PRIMARY KEY,
    token TEXT NOT NULL UNIQUE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE pos (
    id BIGSERIAL PRIMARY KEY,
    pos TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL
);

CREATE TABLE linguas (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(16) UNIQUE NOT NULL,
    name TEXT NOT NULL
);
INSERT INTO linguas(code, name)
    VALUES('bg', 'Bulgarian');
INSERT INTO linguas(code, name)
    VALUES('fi', 'Finnish');
INSERT INTO linguas(code, name)
    VALUES('de', 'German');
INSERT INTO linguas(code, name)
    VALUES('en', 'English');

CREATE TABLE words (
    id BIGSERIAL PRIMARY KEY,
    word TEXT,
    lingua_id BIGINT REFERENCES linguas(id) ON DELETE CASCADE,
    pos_id BIGINT REFERENCES pos(id) ON DELETE CASCADE,
    frequency BIGSERIAL NOT NULL,
    inflections VARCHAR(16)[],
    specials TEXT[],
    additional VARCHAR(16)[],
    emphasis INTEGER[],
    hyphenation INTEGER[],
    peer BIGINT REFERENCES words(id),
    comment TEXT,
    last_modified TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    UNIQUE (word, lingua_id, pos_id, inflections, additional)
);

CREATE TABLE meanings (
    id BIGSERIAL PRIMARY KEY,
    position INTEGER NOT NULL,
    word_id BIGINT REFERENCES words(id) ON DELETE CASCADE,
    context TEXT,
    UNIQUE (id, position, word_id)
);

CREATE TABLE translations (
    meaning_id BIGINT REFERENCES meanings(id) ON DELETE CASCADE,
    lingua_id BIGINT REFERENCES linguas(id) ON DELETE CASCADE,
    translation TEXT NOT NULL,
    PRIMARY KEY(meaning_id, lingua_id)
);
