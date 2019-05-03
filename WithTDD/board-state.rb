require 'ruby2d'

class Coord
  attr_accessor :x, :y
  def initialize(x,y)
    @x,@y = x,y
  end
  def to_s
    "[#{x},#{y}]"
  end
end

class Hex
  attr_accessor :type, :coord, :contained_object
  FLOOR_TYPE=0
  LAVA_TYPE=1
  EXIT_TYPE=2
  ALTAR_TYPE=3

  def initialize(type, coord)
    @type, @coord = type, coord
    @contained_object = nil
  end
  def to_s
    "#{@coord}:#{@type.to_s}"
  end
end

class MovingObject
  attr_accessor :type, :containing_hex
  def initialize(type, containing_hex)
    @type = type
    @containing_hex = containing_hex
  end

  def to_s
    "object: #{@type} in #{@containing_hex}"
  end

  WARRIOR_TYPE=4
  ARCHER_TYPE=5
  BOMBER_TYPE=6
  WIZARD_TYPE=7
  BOMB_TYPE=8
  PLAYER_TYPE=9
end

class Neighbour
  attr_accessor :coord, :direction
  def initialize(coord, direction)
    @coord, @direction = coord, direction
  end
end

class BoardState
  attr_accessor :player
  def initialize(board_state_dsl_representation = nil)
    if(board_state_dsl_representation)
      @hexArray = board_state_dsl_representation.each_with_index.map do | column_string, x |
        column_string.chars.each_with_index.map do | hex_char, y |
          case hex_char
          when "F"
            Hex.new(Hex::FLOOR_TYPE, Coord.new(x,y))
          when "L"
            Hex.new(Hex::LAVA_TYPE, Coord.new(x,y))
          when "P"
            hex = Hex.new(Hex::FLOOR_TYPE, Coord.new(x,y))
            hex.contained_object = MovingObject.new(MovingObject::PLAYER_TYPE, hex)
            @player = hex.contained_object
            hex
          when "E"
            Hex.new(Hex::EXIT_TYPE, Coord.new(x,y))
          else
            raise "unknown char"
          end
        end
      end
      raise "no exit at its place" unless @hexArray[4][9].type == Hex::EXIT_TYPE
    else
      lineLengths = (7..11).to_a + (7..10).to_a.reverse
      @hexArray = lineLengths.each_with_index.map do | len, x |
        Array.new(len) {|y| Hex.new(Hex::FLOOR_TYPE, Coord.new(x,y))}
      end
    end
  end

  def get_hex_at(coord)
    @hexArray[coord.x][coord.y]
  end

  def valid_x_coord?(neighbor_x)
    neighbor_x.between?(0, @hexArray.size - 1)
  end

  def neighbors(coord)
    x,y = coord.x, coord.y
    neighbor_coords = [Coord.new(x, y+1), Coord.new(x, y-1)]
    [-1,1].each do | x_off |
      neighbor_x = x + x_off
      if neighbor_x.between?(0, @hexArray.size-1)
        if(@hexArray[neighbor_x].size > @hexArray[x].size)
          neighbor_coords += [Coord.new(neighbor_x, y), Coord.new(neighbor_x, y+1)]
        else
          neighbor_coords += [Coord.new(neighbor_x, y-1), Coord.new(neighbor_x, y)]
        end
      end
    end

    neighbor_coords.select do | coord |
      coord.x >= 0 && coord.x < @hexArray.size && coord.y >= 0 && coord.y < @hexArray[coord.x].size
    end.map do | neighbor_coord |
      get_hex_at(neighbor_coord)
    end
  end


  #TODO: make this return both coord and direction from the origin
  # def neighbors_new(coord)
  #   x,y = coord.x, coord.y
  #
  #   neighbor_coords = []
  #   neighbor_coords << Neighbour.new(Coord.new(x, y+1),:up)
  #   neighbor_coords << Neighbour.new(Coord.new(x, y-1), :down)
  #
  #   # look left
  #   if valid_x_coord?(x - 1)
  #       if(@hexArray[x - 1].size > @hexArray[x].size)
  #
  #         neighbor_coords << Neighbour.new(Coord.new(neighbor_x, y), :FAIL )
  #         neighbor_coords << Coord.new(neighbor_x, y+1)
  #       else
  #         neighbor_coords << Coord.new(neighbor_x, y-1)
  #         neighbor_coords << Coord.new(neighbor_x, y)
  #       end
  #     end
  #   end
  #
  #   neighbor_coords.select do | coord |
  #     coord.x >= 0 && coord.x < @hexArray.size && coord.y >= 0 && coord.y <= @hexArray[coord.x].size
  #   end.map do | neighbor_coord |
  #     get_hex_at(neighbor_coord)
  #   end
  # end

  def show_image
    temp_floor_tile = Image.new('tiles\tile_floor_1.png')
    hex_width = temp_floor_tile.width - 6
    hex_height = temp_floor_tile.width - 4
    temp_floor_tile.remove
    @hexArray.each_with_index do | line, x |
      bottom_y = hex_height * 11
      y_start = bottom_y - (11 - line.size) * (hex_height / 2)
      line.each_with_index do | hex, y |
        cur_x = x * hex_width
        cur_y = y_start - y * hex_height

        case hex.type
        when Hex::FLOOR_TYPE
          Image.new('tiles\tile_floor_1.png', x:cur_x, y:cur_y)
        when Hex::LAVA_TYPE
          Image.new('tiles\tile_liquid_1.png', x:cur_x, y:cur_y)
        when Hex::EXIT_TYPE
          Image.new('tiles\tile_base.png', x:cur_x, y:cur_y)
          Image.new('tiles\dung_ladderdown.png', x:cur_x, y:cur_y)
        else
          Image.new('tiles\tile_base.png', x:cur_x, y:cur_y)
        end
        if hex.contained_object != nil && hex.contained_object.type == MovingObject::PLAYER_TYPE
          Image.new('tiles\player.png', x:cur_x, y:cur_y)
        end
      end
    end
  end

  def to_s
    @hexArray.each do | line |
      print "     " * (12 - line.size)
      line.each do | hex |
        print hex
        print "     "
      end
      puts
    end
  end
end