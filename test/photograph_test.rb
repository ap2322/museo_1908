require 'minitest/autorun'
require 'minitest/pride'
require './lib/photograph'
require './lib/artist'
require 'pry'

class PhotographTest < Minitest::Test
  def setup
    attributes = {
                    id: "1",
                    name: "Rue Mouffetard, Paris (Boy with Bottles)",
                    artist_id: "4",
                    year: "1954"
                  }

    @photograph = Photograph.new(attributes)
  end

  def test_it_exists
    assert_instance_of Photograph, @photograph
  end

  def test_attributes_at_init
    assert_equal "1", @photograph.id
    assert_equal "Rue Mouffetard, Paris (Boy with Bottles)", @photograph.name
    assert_equal "4", @photograph.artist_id
    assert_equal "1954", @photograph.year
  end

  def test_artist_age_when_taken
    artist_4 = Artist.new({
      id: "4",
      name: "Henri Cartier-Bresson",
      born: "1908",
      died: "2004",
      country: "France"
      })
      # binding.pry

    assert_equal 46, @photograph.artist_age_when_taken(artist_4)
  end
end
