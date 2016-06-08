require 'sinatra'
require 'slim'
require 'sass'
require './song'
require 'sinatra/flash'
require 'pony'
require './sinatra/auth'
require 'sinatra/reloader' if development?

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

helpers do 
	def css(*stylesheets)
		stylesheets.map do |stylesheet|
			      "<link href=\"/#{stylesheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
		end.join
	end
	def current?(path='/')
		(request.path==path || request.path==path+'/') ? "current" : nil
	end
	def set_title
		@title = "Songs by Sinatra"
	end
	def send_message
		Pony.mail(
		    :from => params[:name] + "<" + params[:email] + ">",
		    :to => 'codyloyd@gmail.com',
		    :subject => params[:name] + " has contacted you",
		    :body => params[:message],
		    :port => '587',
		    :via => :smtp,
		    :via_options => {
		      :address 				=> 'smtp.gmail.com',
		      :port                 => '587',
		      :enable_starttls_auto => true,
		      :user_name            => 'codyloyd',
		      :password             => 'ITS A SECRET',
		      :authentication       => :plain,
		      :domain               => 'localhost.localdomain'
		    })
	end
end


before do 
	set_title
end

get '/' do
	erb :home
end

get '/about' do
	@title = "About" 
	erb :about
end

get '/contact' do
	@title = "Contact"	
	erb :contact
end

get '/login' do 
	slim :login	
end

get '/logout' do 
	session.clear
	redirect to('/login')	
end

post '/contact' do
	send_message
	flash[:notice] = "Thank you for your message.  I probably won't get back to you."
	redirect to('/')
end

not_found do 
	erb :not_found
end