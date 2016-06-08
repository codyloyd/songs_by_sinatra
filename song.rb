require 'dm-core'
require 'dm-migrations'

class Song
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :lyrics, Text
  property :length, Integer
  property :released_on, Date
  
  def released_on=date
    super Date.strptime(date, '%m/%d/%Y')
  end
end

module SongHelpers
	def find_songs
		@songs = Song.all
	end
	def find_song
		Song.get(params[:id])
	end
	def create_song
		@song = Song.create(params[:song])
	end
end
helpers SongHelpers

get '/songs' do
	find_songs
	erb :songs
end

post '/songs' do 
	flash[:notice] = "Song successfully added" if create_song
	redirect to("/songs/#{@song.id}")
end

get '/songs/new' do
	halt(401, 'Not Authorized') unless session[:admin] 
	@song = Song.new
	erb :new_song
end

get '/songs/:id' do
	@song = find_song
	erb :show_song
end

put '/songs/:id' do
	song = find_song
	if song.update(params[:song])
		flash[:notice] = "Song successfully updated"
	end
	redirect to("/songs/#{song.id}")
end

get '/songs/:id/edit' do 
	halt(401, 'Not Authorized') unless session[:admin] 
	@song = Song.get(params[:id])
	erb :edit_song
end

delete '/songs/:id' do
	halt(401, 'Not Authorized') unless session[:admin] 
	if find_song.destroy
		flash[:notice] = "Song Deleted"
	end
	redirect to('/songs')
end

DataMapper.finalize 