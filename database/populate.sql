INSERT INTO users (email, password) VALUES
  ('c','$2a$10$LzqpLUOVecv9/gYx6oYXJu2vkFg9kYQm5ih0SzRfJBS9ddfSPStT6'),
  ('y','$2a$10$LzqpLUOVecv9/gYx6oYXJu2vkFg9kYQm5ih0SzRfJBS9ddfSPStT6'),
  ('a','$2a$10$LzqpLUOVecv9/gYx6oYXJu2vkFg9kYQm5ih0SzRfJBS9ddfSPStT6'),
  ('j','$2a$10$LzqpLUOVecv9/gYx6oYXJu2vkFg9kYQm5ih0SzRfJBS9ddfSPStT6');

INSERT INTO profile (user_id, first_name, last_name, latitude, longitude, current_playing)  VALUES
  ( (SELECT user_id FROM users WHERE email = 'c'),'cam','e', 0, 0, '1rbieHTuGFWstwVk9o7Fgr' ),
  ( (SELECT user_id FROM users WHERE email = 'a'),'andre','h', 2, 5, '1rbieHTuGFWstwVk9o7Fgr' ),
  ( (SELECT user_id FROM users WHERE email = 'y'),'yeva','y', 1, 1, NULL ),
  ( (SELECT user_id FROM users WHERE email = 'j'),'jacky', 'j', 14, 0, '1rbieHTuGFWstwVk9o7Fgr' );
