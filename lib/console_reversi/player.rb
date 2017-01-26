require_relative 'piece'

class Player
  def initialize(piece_color:)
    @piece_color = piece_color.to_sym
  end

  def put_piece_on!(board, x:, y:)
    board.put_piece!(piece: Piece.new(type: @piece_color), x: x, y: y)
  end
end
