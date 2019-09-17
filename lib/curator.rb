class Curator
  attr_reader :photographs, :artists

  def initialize
    @photographs = []
    @artists = []
  end

  def add_photograph(photograph)
    @photographs << photograph
  end

  def add_artist(artist)
    @artists << artist
  end

  def find_artist_by_id(id)
    artists.find { |artist| artist.id == id }
  end

  def find_photograph_by_id(id)
    photographs.find { |photo| photo.id == id }
  end

  def find_photographs_by_artist(artist)
    photographs.find_all do |photo|
      photo.artist_id == artist.id
    end
  end

  def artists_with_multiple_photographs
    artists.find_all do |artist|
      find_photographs_by_artist(artist).length > 1
    end
  end

  def photographs_taken_by_artist_from(country)
    artists.find_all { |artist| artist.country == country }
  end

  def load_photographs(file_path)
  end
end
