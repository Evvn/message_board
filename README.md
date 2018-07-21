Create message_board db structure

CREATE ADMIN USER FOR MYSELF ( ALLOW TO DELETE POSTS)

Create pages user will interact with

When user lands on '/' check if logged in

If logged in, send to 'index'

If not, send to 'login.erb'

On login, prompt username and password

If user exists in user db, log them in

If they don't redirect them to login page again

Prompt option to create a new user, and log them in

Redirect logged in user to 'index'

On index page, display list of posts

For each post, display username of post creator

Display comments under each post

Allow users to create a new post (requires image AND content)

Allow users to comment on an existing post (requires content OR image)
