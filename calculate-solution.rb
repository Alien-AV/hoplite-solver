require "test/unit"
require_relative 'board-state.rb'

class CalculateSolution
  # receives BoardState, returns array of moves :up,:down,other move types

  def self.detect_exit_near_me(board_state)
    player_coord = board_state.player.containing_hex.coord
    puts board_state.neighbors(player_coord).select{|hex, direction| hex.type == Hex::EXIT_TYPE}.first.coord
  end

  def self.calculate(board_state)
    detect_exit_near_me(board_state)
  end
end

# class TestCalculateSolution < Test::Unit::TestCase
#   def test_empty_board_player_down_left_from_exit
#     board_dsl=
#         (7..9).map{|i| "F"*i } +
#             ["FFFFFFFFPF"] +
#             ["FFFFFFFFFEF"] +
#             (7..10).reverse_each.map{|i| "F"*i }
#
#     solution = [:upright]
#     board_state = BoardState.new(board_dsl)
#
#     # board_state.show_image
#     # Window.show
#
#     assert_equal solution, CalculateSolution.calculate(board_state)
#   end
#
#   def test_empty_board_player_below_exit
#     board_dsl=
#               (7..10).map{|i| "F"*i } +
#               ["FFFFFFFFPEF"] +
#               (7..10).reverse_each.map{|i| "F"*i }
#
#     solution = [:up]
#     board_state = BoardState.new(board_dsl)
#
#     board_state.to_s
#
#     assert_equal solution, CalculateSolution.calculate(board_state)
#   end
#
# end