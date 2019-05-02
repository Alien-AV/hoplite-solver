require 'test/unit'
require_relative 'board-state'

class NeighborTest < Test::Unit::TestCase
  def setup
    # Do nothing
  end

  def teardown
    # Do nothing
  end

  def test_neighbors_of_0_0
    result = [[0,1],[1,0],[1,1]]
    assert_equal result.sort, BoardState.new().neighbors(Coord.new(0,0)).map{|hex| [hex.coord.x, hex.coord.y]}.sort
  end

  def test_neighbors_of_8_6
    result = [[7,6],[7,7],[8,5]]
    assert_equal result.sort, BoardState.new().neighbors(Coord.new(8,6)).map{|hex| [hex.coord.x, hex.coord.y]}.sort
  end

  def test_neighbors_of_4_5
    result = [[3,4],[3,5],[4,4],[4,6],[5,4],[5,5]]
    assert_equal result.sort, BoardState.new().neighbors(Coord.new(4,5)).map{|hex| [hex.coord.x, hex.coord.y]}.sort
  end
end