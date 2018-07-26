CREATE DATABASE message_board;

CREATE TABLE users (
  id SERIAL4 PRIMARY KEY,
  username VARCHAR(300),
  password_digest VARCHAR(400),
  admin BIT NOT NULL
);

CREATE TABLE posts (
  id SERIAL4 PRIMARY KEY,
  image_url VARCHAR(400),
  content TEXT NOT NULL,
  post_time VARCHAR(100),
  last_activity VARCHAR(100),
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  pinned BIT NOT NULL
);

CREATE TABLE comments (
  id SERIAL4 PRIMARY KEY,
  content TEXT NOT NULL,
  comment_time VARCHAR(100),
  image_url VARCHAR(400),
  post_id INTEGER NOT NULL,
  FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE,
  comment_time VARCHAR(100),
  user_id INTEGER NOT NULL,
  FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE,
  comment_time VARCHAR(100),
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);
