class Searcher
  DIRECTIONS = %i(bottom_right bottom bottom_left right left upper_right upper upper_left)

  def initialize(board, x, y)
    @board = board
    @x = x
    @y = y
  end

  def search(direction, distance)
    pos = position(direction, distance)

    @board.at(pos[:y])&.at(pos[:x]) if !pos[:y].negative? && !pos[:x].negative?
  end

  def position(direction, distance)
    y_distance =
      case direction
      when /\Abottom/
        -1 * distance
      when /\Aupper/
        distance
      else
        0
      end

    x_distance =
      case direction
      when /left\z/
        -1 * distance
      when /right\z/
        distance
      else
        0
      end

    {x: @x + x_distance, y: @y + y_distance}
  end
end
