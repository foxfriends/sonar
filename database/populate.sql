INSERT INTO users (user_id, email, password) VALUES
  ('7342aa9e-0066-4308-befd-c0599594fbf5','c','$2a$10$LzqpLUOVecv9/gYx6oYXJu2vkFg9kYQm5ih0SzRfJBS9ddfSPStT6'),
  ('d3812606-735b-472a-9b51-d7c04ec6e09d','y','$2a$10$LzqpLUOVecv9/gYx6oYXJu2vkFg9kYQm5ih0SzRfJBS9ddfSPStT6'),
  ('1b5f5430-29cb-4383-a797-807ab79fb3a4','a','$2a$10$LzqpLUOVecv9/gYx6oYXJu2vkFg9kYQm5ih0SzRfJBS9ddfSPStT6'),
  ('fd234032-ae2e-42e6-b01a-34edf8ac1f11','j','$2a$10$LzqpLUOVecv9/gYx6oYXJu2vkFg9kYQm5ih0SzRfJBS9ddfSPStT6');

INSERT INTO profile (user_id, first_name, last_name, latitude, longitude, current_playing)  VALUES
  ( (SELECT user_id FROM users WHERE email = 'c'),'cam','e', 0, 0, '1rbieHTuGFWstwVk9o7Fgr' ),
  ( (SELECT user_id FROM users WHERE email = 'a'),'andre','h', 2, 5, '1rbieHTuGFWstwVk9o7Fgr' ),
  ( (SELECT user_id FROM users WHERE email = 'y'),'yeva','y', 1, 1, NULL ),
  ( (SELECT user_id FROM users WHERE email = 'j'),'jacky', 'j', 14, 0, '1rbieHTuGFWstwVk9o7Fgr' );
