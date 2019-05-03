class Hex
  attr_accessor :type, :coord, :contained_object
  FLOOR_TYPE = 0
  LAVA_TYPE = 1
  EXIT_TYPE = 2
  ALTAR_TYPE = 3

  def initialize(type, coord)
    @type, @coord = type, coord
    @contained_object = nil
  end

  def to_s
    "#{@coord.x},#{@coord.y}:#{@type.to_s}#{@contained_object ? @contained_object.type : 0}"
  end
end