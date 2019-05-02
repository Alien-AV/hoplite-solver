require 'test/unit'
require_relative 'board-state.rb'

class CalculateSolution
  # receives BoardState, returns array of moves :up,:down,other move types

  def self.detect_exit_near_me(board_state)
    player_coord = board_state.player.containing_hex.coord
    dir = board_state.neighbors(player_coord).select{| neighbor | neighbor.hex.type == Hex::EXIT_TYPE}.first.direction
    [dir]
  end

  def self.calculate(board_state)
    detect_exit_near_me(board_state)
  end
end