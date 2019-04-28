class Coord
  attr_accessor :x, :y
  def initialize(x,y)
    @x,@y = x,y
  end
end

class MovingObject
  attr_accessor :type, :coord
  def initialize(type)
    @type = type
    @coord = nil
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
    position.playerNeighbors().select{| hex | hex.type == FLOOR_TYPE } # also touching the altar or exit is an option, maybe it's not "step" though
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

  def move_moving_object(moving_object, new_coord)
    if moving_object.coord != nil
      @hexArray[moving_object.coord.x][moving_object.coord.y] = nil
    end
    moving_object.coord = new_coord
    @hexArray[moving_object.coord.x][moving_object.coord.y] = moving_object
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
    neighbors = [[x, y+1], [x, y-1]]
    [-1,1].each do | x_off |
      neighbor_x = x + x_off
      if neighbor_x.between?(0, @hexArray.size-1)
        if(@hexArray[neighbor_x].size > @hexArray[x].size)
          neighbors += [[neighbor_x, y], [neighbor_x, y+1]]
        else
          neighbors += [[neighbor_x, y-1], [neighbor_x, y]]
        end
      end
    end

    neighbors.select do | x, y |
      x >= 0 && x < @hexArray.size && y >= 0 && y <= @hexArray[x].size
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
puts startingPosition
puts startingPosition.generatePotentialPositions


def notMiniMax(startingPosition, depth)
  startingPosition.generatePotentialPositions.map do | potentialPosition, score |
    notMiniMax(potentialPosition, depth - 1) + score
  end.min
end