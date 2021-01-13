class SongsController < ApplicationController
  def index
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist.nil?
        redirect_to artists_path, alert: "Artist not found"
      else
        @songs = @artist.songs
      end
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      @song = @artist.songs.find_by(id: params[:id])
      if @song.nil?
        redirect_to artist_songs_path(@artist), alert: "Song not found"
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    if params[:artist_id] && artist = Artist.find_by_id(params[:artist_id])
      @song = artist.songs.build
    elsif !params[:artist_id]
      @song = Song.new
    else
      redirect_to artists_path
    end

  end

  def create
    if params[:artist_id] && artist = Artist.find_by_id(params[:artist_id])
      @song = artist.songs.build(song_params)
    else
      redirect_to artists_path, alert: "Artist Not Found"
      return
    end

    @song = Song.new(song_params)
    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    if params[:artist_id] && !(artist = Artist.find_by_id(params[:artist_id]) )
      redirect_to artists_path
      return
    elsif params[:artist_id] && !artist.songs.exists?(params[:id])
      redirect_to artist_songs_path(artist)
      return        
    end  
    @song = Song.find_by_id(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name, :artist_id)
  end
end

