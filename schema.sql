SET client_encoding = 'UTF8';

DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL
);
INSERT INTO users(id, email, password) 
  SELECT 0, 'admin', '{SHA512}c7ad44cbad762a5da0a452f9e854fdc1e0e7a52a38015f23f3eab1d80b931dd472634dfac71cd34ebc35d16ab7fb8a90c81f975113d6c7538dc69dd8de9077ec='
  WHERE NOT EXISTS (
    SELECT 1 FROM users WHERE id = 0);

DROP TABLE IF EXISTS groups CASCADE;
CREATE TABLE groups (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);
INSERT INTO groups(id, name) 
  SELECT 0, 'admin'
  WHERE NOT EXISTS (
    SELECT 1 FROM groups WHERE id = 0);

DROP TABLE IF EXISTS user_groups CASCADE;
CREATE TABLE user_groups (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    group_id INTEGER REFERENCES groups(id) ON DELETE CASCADE,
    UNIQUE(user_id, group_id)
);
INSERT INTO user_groups (user_id, group_id)
  SELECT 0, 0
  WHERE NOT EXISTS  (
    SELECT 1 FROM user_groups  WHERE user_id = 0 AND group_id = 0);

DROP TABLE IF EXISTS sessions CASCADE;
CREATE TABLE sessions (
    id SERIAL PRIMARY KEY,
    sid CHAR(128) NOT NULL UNIQUE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    footprint TEXT,
    last_seen TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

DROP TABLE IF EXISTS pos CASCADE;
CREATE TABLE pos (
    id BIGSERIAL PRIMARY KEY,
    pos TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL
);

DROP TABLE IF EXISTS linguas CASCADE;
CREATE TABLE linguas (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(16) UNIQUE NOT NULL,
    name TEXT NOT NULL
);

DROP TABLE IF EXISTS words CASCADE;
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

DROP TABLE IF EXISTS meanings CASCADE;
CREATE TABLE meanings (
    id BIGSERIAL PRIMARY KEY,
    order INTEGER NOT NULL,
    word_id BIGINT REFERENCES words(id) ON DELETE CASCADE,
    context TEXT,
    UNIQUE (id, order, word_id)
);

DROP TABLE IF EXISTS translations CASCADE;
CREATE TABLE translations (
    meaning_id BIGINT REFERENCES meanings(id) ON DELETE CASCADE,
    lingua_id BIGINT REFERENCES linguas(id) ON DELETE CASCADE,
    translation TEXT NOT NULL,
    PRIMARY_KEY(meaning_id, lingua_id)
);
