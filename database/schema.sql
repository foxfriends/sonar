CREATE DATABASE music;

GRANT ALL ON DATABASE music TO musicapp;

SET DATABASE = music;

GRANT ALL ON TABLE users TO musicapp;
GRANT ALL ON TABLE history_songs TO musicapp;
GRANT ALL ON TABLE following_users TO musicapp;
GRANT ALL ON TABLE user_genre_interests TO musicapp;
GRANT ALL ON TABLE genres TO musicapp;
GRANT ALL ON TABLE user_devices TO musicapp;

CREATE TABLE users (
  user_id         CHAR(36) UNIQUE PRIMARY KEY NOT NULL,
  email           VARCHAR(512) UNIQUE NOT NULL,
  password        VARCHAR(512)        NOT NULL,
  join_date       TIMESTAMP           NOT NULL DEFAULT (NOW()::TIMESTAMP)
);

CREATE TABLE profile (
  user_id         CHAR(36) NOT NULL REFERENCES users (user_id),
  first_name      VARCHAR(512)        NOT NULL,
  last_name       VARCHAR(512)        NOT NULL,
  avatar          VARCHAR(512),
  score           INT DEFAULT 0,
  likes           INT DEFAULT 0,
  current_playing VARCHAR(512),
  latitude        DECIMAL,
  longitude       DECIMAL,
  bio             TEXT NOT NULL DEFAULT ''
);

CREATE TABLE history_songs (
  played_at_time  TIMESTAMP   NOT NULL DEFAULT (NOW()::TIMESTAMP),
  user_id         CHAR(36)          NOT NULL REFERENCES users(user_id),
  song_id       VARCHAR(512) NOT NULL
);

CREATE TABLE following_users (
  user_id           CHAR(36) NOT NULL REFERENCES users(user_id),
  following_user_id CHAR(36) NOT NULL REFERENCES users(user_id),
  CONSTRAINT follow_only_once UNIQUE (user_id, following_user_id)
);

CREATE TABLE user_devices (
  user_id   CHAR(36) NOT NULL REFERENCES users(user_id),
  device_id CHAR(64) NOT NULL
);

CREATE TABLE song_likes (
  user_id CHAR(36) NOT NULL REFERENCES users(user_id),
  song_id VARCHAR(512) NOT NULL
);

CREATE TABLE recommendations (
  to_user_id CHAR(36) NOT NULL REFERENCES users(user_id),
  from_user_id CHAR(36) NOT NULL REFERENCES users(user_id),
  song_id VARCHAR(512) NOT NULL,
  liked BOOLEAN DEFAULT FALSE
);
