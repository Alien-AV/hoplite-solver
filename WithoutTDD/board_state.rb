require_relative 'moving_object'
require 'ruby2d'

class BoardState
  attr_accessor :player

  def initialize(board_state_dsl_representation = nil)
    if (board_state_dsl_representation)
      @hexArray = board_state_dsl_representation.each_with_index.map do |column_string, x|
        column_string.chars.each_with_index.map do |hex_char, y|
          case hex_char
          when "F"
            Hex.new(Hex::FLOOR_TYPE, Coord.new(x, y))
          when "L"
            Hex.new(Hex::LAVA_TYPE, Coord.new(x, y))
          when "P"
            hex = Hex.new(Hex::FLOOR_TYPE, Coord.new(x, y))
            @player = MovingObject.new(MovingObject::PLAYER_TYPE)
            place_object(@player, hex)
            hex
          when "E"
            Hex.new(Hex::EXIT_TYPE, Coord.new(x, y))
          else
            raise "unknown char"
          end
        end
      end
      raise "no exit at its place" unless @hexArray[4][9].type == Hex::EXIT_TYPE
    else
      lineLengths = (7..11).to_a + (7..10).to_a.reverse
      @hexArray = lineLengths.each_with_index.map do |len, x|
        Array.new(len) {|y| Hex.new(Hex::FLOOR_TYPE, Coord.new(x, y))}
      end
      @player = MovingObject.new(MovingObject::PLAYER_TYPE)
      place_object(@player, Coord.new(4, 2))
    end
  end

  def clone
    Marshal.load(Marshal.dump(self))
  end

  def get_hex_at(coord)
    @hexArray[coord.x][coord.y]
  end

  def move_moving_object(moving_object, new_coord)
    remove_object(moving_object)
    place_object(moving_object, new_coord)
  end

  def place_object(moving_object, new_coord_or_hex)
    hex = new_coord_or_hex
    hex = get_hex_at(new_coord_or_hex) unless hex.is_a?(Hex)

    moving_object.containing_hex = hex
    moving_object.containing_hex.contained_object = moving_object
  end

  def remove_object(moving_object)
    moving_object.containing_hex.contained_object = nil unless moving_object.containing_hex.nil?
  end

  def place_player(coord)
    move_moving_object(@player, coord)
  end

  def to_s
    @hexArray.each do |line|
      print "      " * (12 - line.size)
      line.each do |hex|
        print hex
        print "      "
      end
      puts
    end
  end

  def show_image
    temp_floor_tile = Image.new('tiles\tile_floor_1.png')
    hex_width = temp_floor_tile.width - 6
    hex_height = temp_floor_tile.width - 4
    temp_floor_tile.remove
    @hexArray.each_with_index do |line, x|
      bottom_y = hex_height * 11
      y_start = bottom_y - (11 - line.size) * (hex_height / 2)
      line.each_with_index do |hex, y|
        cur_x = x * hex_width
        cur_y = y_start - y * hex_height

        case hex.type
        when Hex::FLOOR_TYPE
          Image.new('tiles\tile_floor_1.png', x: cur_x, y: cur_y)
        when Hex::LAVA_TYPE
          Image.new('tiles\tile_liquid_1.png', x: cur_x, y: cur_y)
        when Hex::EXIT_TYPE
          Image.new('tiles\tile_base.png', x: cur_x, y: cur_y)
          Image.new('tiles\dung_ladderdown.png', x: cur_x, y: cur_y)
        else
          Image.new('tiles\tile_base.png', x: cur_x, y: cur_y)
        end
        if hex.contained_object != nil && hex.contained_object.type == MovingObject::PLAYER_TYPE
          Image.new('tiles\player.png', x: cur_x, y: cur_y)
        end
      end
    end
  end

  def neighbors(coord)
    x, y = coord.x, coord.y
    neighbor_coords = [Coord.new(x, y + 1), Coord.new(x, y - 1)]
    [-1, 1].each do |x_off|
      neighbor_x = x + x_off
      if neighbor_x.between?(0, @hexArray.size - 1)
        if (@hexArray[neighbor_x].size > @hexArray[x].size)
          neighbor_coords += [Coord.new(neighbor_x, y), Coord.new(neighbor_x, y + 1)]
        else
          neighbor_coords += [Coord.new(neighbor_x, y - 1), Coord.new(neighbor_x, y)]
        end
      end
    end

    neighbor_coords.select do |coord|
      coord.x >= 0 && coord.x < @hexArray.size && coord.y >= 0 && coord.y < @hexArray[coord.x].size
    end.map do |neighbor_coord|
      get_hex_at(neighbor_coord)
    end
  end

  def player_neighbors
    neighbors(@player.containing_hex.coord)
  end

  def next_possible_board_states
    Step.generate_board_states(self)
  end

  def score
    if (@player.containing_hex.type == Hex::EXIT_TYPE)
      1000
    end
  end
end