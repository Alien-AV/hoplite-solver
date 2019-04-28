class Coord
  attr_accessor :x, :y
  def initialize(x,y)
    @x,@y = x,y
  end
  def to_s
    "[#{x},#{y}]"
  end
end

class MovingObject
  attr_accessor :type, :coord
  def initialize(type)
    @type = type
    @coord = nil
  end

  def to_s
    "MovingObject"
  end

  WARRIOR_TYPE=4
  ARCHER_TYPE=5
  BOMBER_TYPE=6
  WIZARD_TYPE=7
  BOMB_TYPE=8
  PLAYER_TYPE=9
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
    "#{@coord.x},#{@coord.y}:#{@type.to_s}"
  end
end

TURN_ORDER = [:player_move, :player_attack, :exit_stairs, :bombs_explode, :enemies_attack, :enemies_move]

class PotentialMove
  def self.getPossibleMoves(position)
    # prevent this from working in abstract class
  end
end

class Step < PotentialMove
  def self.getPossibleMoves(position)
    # also touching the altar or exit is an option, maybe it's not "step" though
    position.playerNeighbors().select{| hex | hex.type == Hex::FLOOR_TYPE && hex.contained_object == nil}.map do | possible_player_next_hex |
      new_pos = position.clone
      new_pos.move_moving_object(new_pos.player, possible_player_next_hex.coord)
      new_pos
    end
  end
end

POTENTIAL_MOVE_TYPES = [Step, :lunge, :bash, :throw]

class Position
  def initialize
    lineLengths = (7..11).to_a + (7..10).to_a.reverse
    @hexArray = lineLengths.each_with_index.map do | len, x |
      Array.new(len) {|y| Hex.new(0, Coord.new(x,y))}
    end
    @player_location = Coord.new(4,2)
    place_player(@player_location)
  end

  def clone
    Marshal.load(Marshal.dump(self))
  end

  def move_moving_object(moving_object, new_coord)
    if moving_object.coord != nil
      @hexArray[moving_object.coord.x][moving_object.coord.y] = nil
    end
    moving_object.coord = new_coord
    @hexArray[moving_object.coord.x][moving_object.coord.y].contained_object = moving_object
  end

  def player
    @hexArray[@player_location.x][@player_location.y].contained_object
  end

  def place_player(coord)
    move_moving_object(MovingObject.new(MovingObject::PLAYER_TYPE), coord)
    @player_location = coord
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

  def neighbors(coords)
    x,y = coords.x, coords.y
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
      coord.x >= 0 && coord.x < @hexArray.size && coord.y >= 0 && coord.y <= @hexArray[coord.x].size
    end.map do | neighbor_coord |
      @hexArray[neighbor_coord.x][neighbor_coord.y]
    end
  end

  def playerNeighbors
    neighbors(@player_location)
  end

  def generatePotentialPositions
    self.clone
  end
end

startingPosition = Position.new
# puts startingPosition
# puts
# puts startingPosition.generatePotentialPositions
# puts
Step.getPossibleMoves(startingPosition).each do | possible_pos |
  puts possible_pos
  puts; puts
end


def notMiniMax(startingPosition, depth)
  startingPosition.generatePotentialPositions.map do | potentialPosition, score |
    notMiniMax(potentialPosition, depth - 1) + score
  end.min
end