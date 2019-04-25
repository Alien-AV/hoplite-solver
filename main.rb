class MovingObject
  attr_accessor :type
  def initialize(type, x, y)
    @type, @x, @y = type, x, y
  end
  WARRIOR_TYPE=4
  ARCHER_TYPE=5
  BOMBER_TYPE=6
  WIZARD_TYPE=7
  BOMB_TYPE=8
  PLAYER_TYPE=9
end

class Hex
  attr_accessor :type
  attr_accessor :contained_object
  FLOOR_TYPE=0
  LAVA_TYPE=1
  EXIT_TYPE=2
  ALTAR_TYPE=3

  def initialize(type, x, y)
    @type, @x, @y = type, x, y
    @contained_object = nil
  end
  def to_s
    "#{@x},#{@y}:#{@type.to_s}"
    # "#{@id.to_s}"
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
      Array.new(len) {|y| Hex.new(0, x, y)}
    end
    @player_location = [4,2]
    @hexArray[@player_location[0]][@player_location[1]].type = Hex::PLAYER_TYPE
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
  def neighbors(x,y)
    # if adjacent line is longer, make a neighbor with y+1, and a neighbor with y
    # if shorter, make a neighbor with y-1 and a neighbor with y
    # always make a neighbor with

    neighbors = [[x, y+1], [x, y-1]]
    [-1,1].each do | x_off |
      if(x+x_off >= 0 && x+x_off < @hexArray.size)
        if(@hexArray[x+x_off].size > @hexArray[x].size)
          neighbors += [[x+x_off, y], [x+x_off, y+1]]
        else
          neighbors += [[x+x_off, y-1], [x+x_off, y]]
        end
      end
    end

    neighbors.select do | x, y |
      x >= 0 && x < @hexArray.size && y >= 0 && y <= @hexArray[x].size
    end
  end
  def playerNeighbors
    neighbors(*@player_location)
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