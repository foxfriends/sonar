CREATE DATABASE music;

GRANT ALL ON DATABASE music TO musicapp;

SET DATABASE = music;

CREATE TABLE users (
  user_id   SERIAL PRIMARY KEY,
  username  VARCHAR(512) UNIQUE NOT NULL,
  password  VARCHAR(512) NOT NULL,
  join_date TIMESTAMP NOT NULL DEFAULT (NOW()::TIMESTAMP),
  avatar    VARCHAR(512),
  score     INT DEFAULT 0,
  current_playing VARCHAR(512),
  coord     POINT -- (LNG, LAT) ! don't forget
  -- NOTE: see https://www.postgresql.org/docs/9.1/static/earthdistance.html
);

CREATE TABLE history_songs (
  user_id   INT          NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  song_name VARCHAR(512) NOT NULL
);

CREATE TABLE following_users (
  user_id           INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  following_user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE user_genre_interests (
  user_id   INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  genre_id  INT NOT NULL REFERENCES genres(genre_id) ON DELETE CASCADE
);

-- TODO: will this be on Spotify??
CREATE TABLE genres (
  genre_id    SERIAL PRIMARY KEY,
  genre_name  VARCHAR(512) NOT NULL
)
