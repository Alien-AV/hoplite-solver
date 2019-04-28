require_relative 'board_state.rb'
require "test/unit"

class CalculateSolution
  # receives BoardState, returns array of moves :up,:down,other move types

  def self.calculate(board_state)
    [:up]*8
  end
end

class TestCalculateSolution < Test::Unit::TestCase
  def test_empty_board
    assert_equal [:up]*8, CalculateSolution.calculate(BoardState.new)
  end
  def test_one_lava_in_center
    board_dsl=(7..10).map{|i| "F"*i } + ["FPLFFFFFFEF"] + (7..10).reverse_each.map{|i| "F"*i }
    solution = []
    board_state = BoardState.new(board_dsl)
    puts board_state

    assert_equal solution, CalculateSolution.calculate(board_state)
  end
end