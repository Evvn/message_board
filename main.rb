require 'sinatra'
require 'sinatra/reloader'
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

end

get '/' do
  # if user is not logged in, redirect to login page
  redirect '/login' unless logged_in?

  erb :index
end

get '/login' do

  erb :login
end

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

delete '/session' do
  # delete the session
  session[:user_id] = nil

  redirect '/login'
end

get '/new_user' do

  erb :new_user
end

post '/create_user' do
    # check that params are not empty
    if params[:username] == "" || params[:password] == ""
      redirect '/new__user'
    end
    # add new user object to db
    # set admin rights to false (0)
    User.create!(username: params[:username], password: params[:password], admin: "0");
    # set user by new user username
    user = User.find_by(username: params[:username])
    # create new session
    session[:user_id] = user.id
    # redirect to index page
    redirect '/'
end
