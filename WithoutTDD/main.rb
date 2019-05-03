require 'ruby2d'

require_relative 'coord.rb'
require_relative 'moving_object.rb'
require_relative 'hex.rb'
require_relative 'potential_move_types/step.rb'
require_relative 'board_state.rb'

TURN_ORDER = [:player_move, :player_attack, :exit_stairs, :bombs_explode, :enemies_attack, :enemies_move]
POTENTIAL_MOVE_TYPES = [Step, :lunge, :bash, :throw]

def notMiniMax(startingPosition, depth)
  startingPosition.next_possible_board_states.map do | potentialPosition, score |
    notMiniMax(potentialPosition, depth - 1) + score
  end.min
end


def make_fake_board
  board_dsl = (7..10).map {|i| "F" * i} + ["FPLFFFFFFEF"] + (7..10).reverse_each.map {|i| "F" * i}
  BoardState.new board_dsl
end

def display_states_waiting_for_keypress_or_mouseclick(board_states_list)
  show_next_state = lambda do | _event |
    next_state = board_states_list.shift
    if next_state
      next_state.show_image
    else
      close
    end
  end

  show_next_state.call(nil)
  Window.on(:key_down, &show_next_state)
  Window.on(:mouse_up, &show_next_state)
  Window.show
end

fake_board = make_fake_board
possible_next_states = fake_board.next_possible_board_states
display_states_waiting_for_keypress_or_mouseclick(possible_next_states)

