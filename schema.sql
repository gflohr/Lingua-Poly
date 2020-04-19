SET client_encoding = 'UTF8';
CREATE EXTENSION IF NOT EXISTS citext;

CREATE TABLE identity_providers ( 
        id SERIAL PRIMARY KEY,
        name TEXT NOT NULL UNIQUE
);
INSERT INTO identity_providers(name) SELECT 'local'
  WHERE NOT EXISTS (
    SELECT 1 FROM identity_providers WHERE name  = 'local'
  );
INSERT INTO identity_providers(name) SELECT 'Facebook'
  WHERE NOT EXISTS (
    SELECT 1 FROM identity_providers WHERE name  = 'Facebook'
  );
INSERT INTO identity_providers(name) SELECT 'Google'
  WHERE NOT EXISTS (
    SELECT 1 FROM identity_providers WHERE name  = 'Google'
  );

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email CITEXT UNIQUE,
    username CITEXT UNIQUE,
    password TEXT,
    identity_provider_id INTEGER
        REFERENCES identity_providers(id) ON DELETE CASCADE,
    external_id TEXT,
    confirmed BOOLEAN NOT NULL DEFAULT 'f',
    homepage TEXT,
    description TEXT,
    UNIQUE(identity_provider_id, external_id),
    CHECK((email IS NOT NULL) OR (external_id IS NOT NULL))
);
INSERT INTO users(id, email, username, password, identity_provider_id, confirmed)
  SELECT 0, 'placeholder@example.com', 'admin', '{ARGON2}$argon2id$v=19$m=32768,t=12,p=1$MTM1QzRDNkEtMDUzOS0xMUVBLUI0NjItM0ZCMDQyNjU0QTBB$tir07b6/y+fWwkvJe9Cw3A', '1','t'
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
    fingerprint TEXT,
    identity_provider_id INTEGER NOT NULL REFERENCES identity_providers(id) ON DELETE CASCADE,
    nonce TEXT,
    token TEXT,
    token_expires TIMESTAMP WITH TIME ZONE,
    last_seen TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE auth_tokens (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    selector TEXT NOT NULL UNIQUE,
    last_seen TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TYPE token_type
        AS ENUM('registration', 'passwordReset', 'emailChange');
CREATE TABLE tokens (
    id SERIAL PRIMARY KEY,
    purpose token_type NOT NULL,
    token TEXT NOT NULL UNIQUE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(purpose, user_id)
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

CREATE TABLE configs (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    value TEXT,
    expires TIMESTAMP WITH TIME ZONE NOT NULL
);
