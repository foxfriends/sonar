CREATE DATABASE music;

GRANT ALL ON DATABASE music TO musicapp;

SET DATABASE = music;

CREATE TABLE users (
  user_id   SERIAL PRIMARY KEY,
  email     VARCHAR(512) UNIQUE NOT NULL,
  username  VARCHAR(512) UNIQUE NOT NULL,
  password  VARCHAR(512) NOT NULL,
  join_date TIMESTAMP NOT NULL DEFAULT (NOW()::TIMESTAMP)
);
