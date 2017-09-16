CREATE DATABASE music;

SET DATABASE = music;

CREATE TABLE users (
  user_id   SERIAL PRIMARY KEY,
  username  VARCHAR(512) UNIQUE NOT NULL,
  password  VARCHAR(512) NOT NULL,
  join_date TIMESTAMP NOT NULL DEFAULT (NOW()::TIMESTAMP),
  avatar    VARCHAR(512),
  score     INT,
  current_playing VARCHAR(512),
  coord     POINT
);

CREATE TABLE history_songs (
  user_id INT REFERENCES users(user_id),
  song_name VARCHAR(512)
);

CREATE TABLE following_users (
  user_id   INT REFERENCES users(user_id),
  following_user_id INT REFERENCES users(user_id)
);

CREATE TABLE user_genre_interests (
  user_id   INT REFERENCES users(user_id),
  genre_id  INT REFERENCES genres(genre_id)
);

CREATE TABLE genres (
  genre_id    SERIAL PRIMARY KEY,
  genre_name  VARCHAR(512) NOT NULL
)
