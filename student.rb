
require 'dm-core'
require 'dm-migrations'
require './main'
require './comment'

#enable :sessions
DataMapper.setup(:default, ENV['DATABASE_URL']|| "sqlite3://#{Dir.pwd}/development.db")
configure do
  enable :sessions
  set :username, "shivangi"        # apurva changed to shivangi
  set :password, "shivu123"      # login123 changed to shivu123
end


class Student
  include DataMapper::Resource
  property :id, Serial
  property :firstname, String
  property :lastname, String
  property :birthday, Date
  property :address, String
  property :studentid, String
  property :cellno, Integer

  def birthday=date
    super Date.strptime(date, '%m/%d/%Y')
  end
end

DataMapper.finalize
#DataMapper.auto_migrate!
DataMapper.auto_upgrade!

get '/students' do
  @students = Student.all
  if session[:admin] == true
    erb :students, :layout => :display2
  else
    erb :students, :layout => :display1    # changed display1 to layout
  end
end

get '/students/new' do
  redirect to('/logout') unless session[:admin]
  student = Student.new
  erb :newstudent, :layout => :display2
end

get '/login' do
  erb :login
end

post '/login' do
  if params[:username] == settings.username && params[:password] == settings.password
      session[:admin] = true
      erb :logged, :layout => :display2
  else
    erb :login
  end
end

get '/logout' do
session.clear
session[:admin] = false
erb :login, :layout => :layout  #changedlayout to display2

end

#Route for the new student form
get '/students/new' do
  redirect to('/logout') unless session[:admin]
  @student = Student.new
  erb :newstudent
end

#Shows a single student
get '/students/:id' do
  @student = Student.get(params[:id])
  #erb :show_student
  if session[:admin] == true
    erb :show_student, :layout => :display2
  else
    erb :show_student, :layout => :layout
  end
end

#Route for the form to edit a single student
get '/students/:id/edit' do
  redirect to('/logout') unless session[:admin]
  @student = Student.get(params[:id])
  #erb :edit_student
  if session[:admin] == true
    erb :edit_student, :layout => :display2
  else
    erb :edit_student, :layout => :layout
  end
end

#Creates new student
post '/students' do
  redirect to('/logout') unless session[:admin]
  @student = Student.create(params[:student])
  redirect to('/students')
end

#Edits a single student
put '/students/:id' do
  redirect to('/logout') unless session[:admin]
  @student = Student.get(params[:id])
  @student.update(params[:student])
  redirect to("/students/#{@student.id}")
end

#Deletes a single student
delete '/students/:id' do
  redirect to('/logout') unless session[:admin]
  Student.get(params[:id]).destroy
  redirect to('/students')
end
