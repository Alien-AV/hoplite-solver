class MovingObject
  attr_accessor :type, :containing_hex

  def initialize(type)
    @type = type
  end

  def to_s
    "object: #{@type} in #{@containing_hex}"
  end

  WARRIOR_TYPE = 4
  ARCHER_TYPE = 5
  BOMBER_TYPE = 6
  WIZARD_TYPE = 7
  BOMB_TYPE = 8
  PLAYER_TYPE = 9
end