require 'sinatra'
require 'sass'
require './student'
require './comment'

require 'sinatra/reloader' if development?

#enable :sessions
configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL']|| "sqlite3://#{Dir.pwd}/development.db") #connecting to db
end

configure :development do
    DataMapper.setup(:default, ENV['DATABASE_URL']|| "sqlite3://#{Dir.pwd}/development.db") #connecting to db
end



get('/style.scss'){ scss :style } 

get '/' do
  	if session[:admin] == true
		erb :home, :layout => :display2
	else
		erb :home
	end
end

get '/about' do
 	@title = "All About The Website"
  	if session[:admin] == true
		erb :about, :layout => :display2
	else
		erb :about
	end
end

get '/contact' do
	@title = "Find creator details here!"
	if session[:admin] == true
		erb :contact, :layout => :display2
	else
		erb :contact
	end
end

get '/video' do
	@title = "Explore SCU!!"
	if session[:admin] == true
		erb :video, :layout => :display2
	else
		erb :video
	end
end
