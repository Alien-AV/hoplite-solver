require_relative '../hex'

class Step
  def self.generate_board_states(board_state)
    # also touching the altar or exit is an option, maybe it's not "step" though
    board_state.player_neighbors.select do |hex|
      [Hex::FLOOR_TYPE, Hex::EXIT_TYPE].include?(hex.type) && hex.contained_object == nil
    end.map do |possible_player_next_hex|
      new_board_state = board_state.clone
      new_board_state.move_moving_object(new_board_state.player, possible_player_next_hex.coord)
      new_board_state
    end
  end
end