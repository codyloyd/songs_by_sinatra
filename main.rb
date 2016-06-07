require 'sinatra'
require 'sass'
require  './song'
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

get '/songs' do
	@songs = Song.all
	erb :songs
end

post '/songs' do 
	song = Song.create(params[:song])
	redirect to("/songs/#{song.id}")
end

get '/songs/new' do
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
	@song = Song.get(params[:id])
	erb :edit_song
end

delete '/songs/:id' do
	Song.get(params[:id]).destroy
	redirect to('/songs')
end

not_found do 
	erb :not_found
end