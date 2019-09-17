require 'minitest/autorun'
require 'minitest/pride'
require './lib/curator'
require './lib/photograph'
require './lib/artist'
require 'pry'

class CuratorTest < Minitest::Test
  def setup
    @curator = Curator.new
  end

  def photos
    @photo_1 = Photograph.new({
       id: "1",
       name: "Rue Mouffetard, Paris (Boy with Bottles)",
       artist_id: "1",
       year: "1954"
       })
    @photo_2 = Photograph.new({
       id: "2",
       name: "Moonrise, Hernandez",
       artist_id: "2",
       year: "1941"
       })
    @photo_3 = Photograph.new({
      id: "3",
      name: "Identical Twins, Roselle, New Jersey",
      artist_id: "3",
      year: "1967"
      })
   @photo_4 = Photograph.new({
      id: "4",
      name: "Monolith, The Face of Half Dome",
      artist_id: "3",
      year: "1927"
      })
  end

  def artists
    @artist_1 = Artist.new({
      id: "1",
      name: "Henri Cartier-Bresson",
      born: "1908",
      died: "2004",
      country: "France"
      })

    @artist_2 = Artist.new({
      id: "2",
      name: "Ansel Adams",
      born: "1902",
      died: "1984",
      country: "United States"
      })
    @artist_3 = Artist.new({
      id: "3",
      name: "Diane Arbus",
      born: "1923",
      died: "1971",
      country: "United States"
      })
    @artist_4 = Artist.new({
      id: "4",
      name: "Bob Ross",
      born: "1940",
      died: "1990",
      country: "United States",
      })
  end

  def test_it_exists
    assert_instance_of Curator, @curator
  end

  def test_attributes_at_init
    assert_equal [], @curator.photographs
    assert_equal [], @curator.artists
  end

  def test_add_photograph
    photos
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)

    assert_equal [@photo_1, @photo_2], @curator.photographs
  end

  def test_add_artist
    artists
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)

    assert_equal [@artist_1, @artist_2], @curator.artists
  end

  def test_find_artist_by_id
    artists
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)

    assert_equal @artist_1, @curator.find_artist_by_id("1")
    assert_equal @artist_2, @curator.find_artist_by_id("2")
  end

  def test_find_photograph_by_id
    photos
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)

    assert_equal @photo_2, @curator.find_photograph_by_id("2")
    assert_equal @photo_1, @curator.find_photograph_by_id("1")
  end

  def test_find_photographs_by_artist
    photos
    artists
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)

    assert_equal [@photo_3, @photo_4], @curator.find_photographs_by_artist(@artist_3)
  end

  def test_artists_with_multiple_photographs
    photos
    artists
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    @curator.add_artist(@artist_4)
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)

    assert_equal [@artist_3], @curator.artists_with_multiple_photographs
  end

  def test_photographs_taken_by_artist_from_country
    photos
    artists
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    us_artists = [@artist_2, @artist_3]

    assert_equal us_artists, @curator.photographs_taken_by_artist_from("United States")
    assert_equal [], @curator.photographs_taken_by_artist_from("Argentina")
  end

  def test_load_photographs
    curator2 = Curator.new
    curator2.load_photographs('./data/photographs.csv')

    assert_equal 4, curator2.photographs.length
    assert_instance_of Photograph, curator2.photographs[0]
    assert_equal "Rue Mouffetard, Paris (Boy with Bottles)", curator2.photographs[0].name
  end

  def test_load_artists
    curator3 = Curator.new
    curator3.load_artists('./data/artists.csv')

    assert_equal 6, curator3.artists.length
    assert_instance_of Artist, curator3.artists[0]
    assert_equal "Henri Cartier-Bresson", curator3.artists[0].name
  end

  def test_photos_taken_between_years
    curator2 = Curator.new
    curator2.load_photographs('./data/photographs.csv')
    photo_objs = curator2.photographs

    assert_equal [photo_objs[0], photo_objs[3]], curator2.photographs_taken_between(1950..1965)
  end

  def test_artists_photographs_by_age
    curator3 = Curator.new
    curator3.load_artists('./data/artists.csv')
    curator3.load_photographs('./data/photographs.csv')
    diane_arbus = curator3.find_artist_by_id("3")
    # hash where the keys are the Artists age when they took a photograph,
    # and the values are the names of the photographs
    expected = {44=>"Identical Twins, Roselle, New Jersey",
                39=>"Child with Toy Hand Grenade in Central Park"}
    assert_equal expected, curator3.artists_photographs_by_age(diane_arbus)
  end

end
