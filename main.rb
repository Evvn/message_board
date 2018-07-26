require 'sinatra'
configure { set :server, :puma }
# comment this out before going live on heroku
# require 'sinatra/reloader'
require 'pg'
require 'pry'
require_relative "db_config"
require_relative "models/post"
require_relative "models/comment"
require_relative "models/user"

enable :sessions

helpers do

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  # Rack::Utils helper to escape html outputs
  def esc(text)
    Rack::Utils.escape_html(text)
  end

end

# direct user if logged in to index, or if not logged in to login page
get '/' do
  # if user is not logged in, redirect to login page
  redirect '/login' unless logged_in?

  # @posts = Post.all.sort_by{ |p| p.last_activity }.reverse

  # For page 1
  @posts = Post.all.sort_by{ |p| p.last_activity }.last(10).reverse
  @page_number = '1'

  # Use .last(20) for 2nd page, .last(30) for 3rd page etc
  # Post.all.sort_by{ |p| p.last_activity }.last(20).reverse.last(10)

  erb :index
end

get '/page/:page_number' do
  # if user is not logged in, redirect to login page
  redirect '/login' unless logged_in?

  if params[:page_number] == '1'
    redirect '/'
  end

  load_posts = (params[:page_number] + '0').to_i

  @page_number = params[:page_number]
  @posts = Post.all.sort_by{ |p| p.last_activity }.last(load_posts).reverse.last(10)

  # Use .last(20) for 2nd page, .last(30) for 3rd page etc
  # Post.all.sort_by{ |p| p.last_activity }.last(20).reverse.last(10)

  erb :index
end

not_found do
  status 404
  erb :pnf
end

get '/login' do
  if logged_in?
  redirect '/'
  end

  erb :login
end

get '/session' do

  redirect '/'
end

# log in user and add them to session if details are correct
post '/session' do
  # grab email and password(params)
  # find the user by username
  user = User.find_by(username: params[:username])
  # authenticate user with password
  if user && user.authenticate(params[:password])
    # create new session
    session[:user_id] = user.id
    # redirect to index page
    redirect '/'
  else
    erb :login
  end

end

# log out user from current session
delete '/session' do
  # delete the session
  session[:user_id] = nil

  redirect '/login'
end

get '/new_user' do

  erb :new_user
end

# create a new user
post '/create_user' do
    # check that params are not empty
    if params[:username] == "" || params[:password] == ""
      redirect '/new_user'
    end
    # check if password confirmation is incorrect
    if params[:password] != params[:password_confirm]
      redirect 'new_user'
    end
    # add new user object to db
    # set admin rights to false (0)
    # why i do it this way lol bang-bang
    # User.create!(username: params[:username], password: params[:password], admin: "0");
    user = User.new(username: params[:username], password: params[:password], admin: "0")
    if user.save == false
      redirect '/new_user'
    else
      user.save
    end
    # set user by new user username
    user = User.find_by(username: params[:username])
    # create new session
    session[:user_id] = user.id
    # redirect to index page
    redirect '/'
end

# redirect to new post page
get '/new_post' do
  # if user is not logged in, redirect to login page
  redirect '/login' unless logged_in?

  erb :new_post
end

# redirect to new comment page
get '/new_comment/:id' do
  # if user is not logged in, redirect to login page
  redirect '/login' unless logged_in?

  @post = Post.find( params[:id] )

  erb :new_comment
end

get '/new_comment' do

  redirect '/'
end

# create new post
post '/post/new' do
  # get inputs from new post form
  post = Post.new
  post.image_url = params[:image_url]
  post.content = params[:content]
  post.post_time = (Time.now.utc + 10.hours).strftime("%-d/%m/%y %H:%M:%S")
  post.last_activity = (Time.now.utc + 10.hours).strftime("%-d/%m/%y %H:%M:%S")
  post.user_id = current_user.id
  post.save

  #delete oldest post to make room for newest (50 post capacity)
  if Post.all.length > 50
    oldest_post = Post.all.sort_by{ |p| p.last_activity }.first
    oldest_post.destroy
  end

  # get post redirect
  redirect '/'
end

# show post details by id
get '/post/:page_number/:id' do
  # if user is not logged in, redirect to login page
  redirect '/login' unless logged_in?

  # redirect if post not found
  if Post.find_by(id: params[:id] ) == nil
    redirect '/404'
  end

  @page_number = params[:page_number]
  @post = Post.find( params[:id] )
  @comments = @post.comments

  erb :post
end

# post new comment on 'post' page
post '/comment/new' do
# if user is not logged in, redirect to login page
  redirect '/login' unless logged_in?

  comment = Comment.new
  comment.image_url = params[:image_url]
  comment.content = params[:content]
  comment.post_id = params[:post_id]
  comment.comment_time = (Time.now.utc + 10.hours).strftime("%-d/%m/%y %H:%M:%S")
  comment.user_id = current_user.id
  comment.save

  # update latest_activity of post to comment time
  post = Post.find( params[:post_id] )
  post.last_activity = (Time.now.utc + 10.hours).strftime("%-d/%m/%y %H:%M:%S")
  post.save

  redirect "/post/#{ params[:post_id] }"
end

# delete post functionality
delete '/post/:id' do
  post = Post.find( params[:id] )
  post.destroy

  redirect '/'
end

# delete comment functionality
delete '/comment/:id' do
  comment = Comment.find( params[:id] )
  comment.destroy

  redirect "/post/#{ params[:post_id] }"
end
