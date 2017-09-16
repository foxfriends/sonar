CREATE DATABASE music;

GRANT ALL ON DATABASE music TO musicapp;

SET DATABASE = music;

GRANT ALL ON TABLE users TO musicapp;

CREATE TABLE users (
  user_id         SERIAL PRIMARY KEY,
  first_name      VARCHAR(512)        NOT NULL,
  last_name       VARCHAR(512)        NOT NULL,
  email           VARCHAR(512) UNIQUE NOT NULL,
  password        VARCHAR(512)        NOT NULL,
  join_date       TIMESTAMP           NOT NULL DEFAULT (NOW()::TIMESTAMP),
  avatar          VARCHAR(512),
  score           INT DEFAULT 0,
  likes           INT DEFAULT 0,
  current_playing VARCHAR(512),
  latitude        DECIMAL,
  longitude       DECIMAL
);

CREATE TABLE history_songs (
  history_id SERIAL PRIMARY KEY,
  user_id   INT          NOT NULL REFERENCES users(user_id),
  song_name VARCHAR(512) NOT NULL
);

CREATE TABLE following_users (
  user_id           INT NOT NULL REFERENCES users(user_id),
  following_user_id INT NOT NULL REFERENCES users(user_id)
);

CREATE TABLE user_genre_interests (
  user_id   INT NOT NULL REFERENCES users(user_id),
  genre_id  INT NOT NULL REFERENCES genres(genre_id)
);

-- TODO: will this be on Spotify??
CREATE TABLE genres (
  genre_id    SERIAL PRIMARY KEY,
  genre_name  VARCHAR(512) NOT NULL
);

CREATE TABLE user_devices (
  user_id   INT NOT NULL REFERENCES users(user_id),
  device_id CHAR(64) NOT NULL
);
