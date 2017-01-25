require_relative 'piece'

class Board
  def initialize
    @board = initialize_board
  end

  def pretty_print
    @board.each_with_index do |row, i|
      row.each_with_index do |p, j|
        if p == 0
          print (i + j) % 2 == 0 ? "\e[48;5;22m　" : "\e[48;5;232m　"
        else
          p.pretty_print
        end
      end

      print "\e[0m\n"
    end
  end

  private

  def initialize_board
    board = 8.times.map { [0].cycle(8).to_a }

    board[3][3] = Piece.new(type: :black)
    board[3][4] = Piece.new(type: :white)
    board[4][3] = Piece.new(type: :white)
    board[4][4] = Piece.new(type: :black)

    board
  end
end
