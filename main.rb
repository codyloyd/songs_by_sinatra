require 'sinatra'
require 'sass'
require 'sinatra/reloader'


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

not_found do 
	erb :not_found
end