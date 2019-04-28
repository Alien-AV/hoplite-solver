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

class BoardState
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
