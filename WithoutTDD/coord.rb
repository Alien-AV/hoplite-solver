class Coord
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def to_s
    "[#{x},#{y}]"
  end
end