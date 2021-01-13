module SongsHelper

  def artist_select(song, f)
    if params[:artist_id] 
      "Artist: #{song.artist_name}" 
    else 
      f.collection_select :artist_id, Artist.all, :id, :name 
    end
  end  

end
