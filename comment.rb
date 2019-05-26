
require 'dm-core'
require 'dm-migrations'
require './main'
require './student'
require 'dm-timestamps'
require 'dm-validations'

#enable :sessions

DataMapper.setup(:default, ENV['DATABASE_URL']|| "sqlite3://#{Dir.pwd}/development.db")
configure do
    enable :sessions
    set :username, "shivangi"       # umang changed to shivangi
    set :password, "shivu123"       # password changed to shivu123
end


class Comment
  include DataMapper::Resource
  property :cid, Serial
  property :comment, String, :required => true
  property :name, String
  property :created_at, DateTime
  property :updated_at, DateTime
end

DataMapper.finalize
#DataMapper.auto_migrate!
DataMapper.auto_upgrade!


get '/comments' do
  @comments = Comment.all
  if session[:admin] == true
    erb :comments, :layout => :display2
  else
    erb :comments, :layout => :display1  #display1 changed to layout
  end
end

get '/comments/new' do
  comment = Comment.new
  erb :newcomment
end

#New comment form
get '/comments/new' do
  halt(401, 'Not Authorized, Please go back login') unless session[:admin]
  @comment = Comment.new
  erb :newcomment
end

#Single comment
get '/comments/:cid' do
  @comment = Comment.get(params[:cid])
  #erb :show_comment
  if session[:admin] == true
    erb :showcomment, :layout => :display2
  else
    erb :showcomment, :layout => :layout
  end
end
#Editing a single comment
get '/comments/:cid/edit' do
  halt(401, 'Not Authorized, Please go back login') unless session[:admin]
  @comment = Comment.get(params[:cid])
  #erb :edit_comment
  if session[:admin] == true
    erb :editcomment, :layout => :display2
  else
    erb :editcomment, :layout => :layout
  end
end
#Creating a new comment
post '/comments' do
  halt(401, 'Not Authorized') unless session[:admin]
  @comment = Comment.create(params[:comment])
  redirect to('/comments')
end

#Editing a single student
put '/comments/:cid' do
  halt(401, 'Not Authorized') unless session[:admin]
  @comment = Comment.get(params[:cid])
  @comment.update(params[:comment])
  redirect to("/comments/#{@comment.cid}")
  
end

#Deletes a single comment
delete '/comments/:cid' do
  halt(401, 'Not Authorized, Please go back login') unless session[:admin]
  Comment.get(params[:cid]).destroy
  redirect to('/comments')
end
