# require 'sinatra'
# require 'sass'
# require 'slim'
# require  './song'
# # require 'dm-core'
# # require 'dm-migrations'
# require 'data_mapper'
# require 'sinatra/reloader' if development?

# configure do
# 	enable :sessions
# 	set :username, 'cody'
# 	set :password, 'password'
# end
# configure :development do
#   DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
# end
# configure :production do
#   DataMapper.setup(:default, ENV['DATABASE_URL'])
# end


require 'sinatra'
require 'slim'
require 'sass'
require './song'

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
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

get '/songs' do
	@songs = Song.all
	erb :songs
end

post '/songs' do 
	song = Song.create(params[:song])
	redirect to("/songs/#{song.id}")
end

get '/songs/new' do
	halt(401, 'Not Authorized') unless session[:admin] 
	@song = Song.new
	erb :new_song
end

get '/songs/:id' do
	@song = Song.get(params[:id])
	erb :show_song
end

put '/songs/:id' do
	song = Song.get(params[:id])
	song.update(params[:song])
	redirect to("/songs/#{song.id}")
end

get '/songs/:id/edit' do 
	halt(401, 'Not Authorized') unless session[:admin] 
	@song = Song.get(params[:id])
	erb :edit_song
end

delete '/songs/:id' do
	halt(401, 'Not Authorized') unless session[:admin] 
	Song.get(params[:id]).destroy
	redirect to('/songs')
end

get '/login' do 
	slim :login	
end

post '/login' do 
	if params[:username] == settings.username && params[:password] == settings.password
		session[:admin] = true
		redirect to('/songs')
	else
		slim :login
	end
end

get '/logout' do 
	session.clear
	redirect to('/login')	
end

not_found do 
	erb :not_found
end