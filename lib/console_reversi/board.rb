class ConsoleReversi
  class Board
    def initialize
      @board = initialize_board
    end

    def put_piece!(piece:, x:, y:)
      @board[y][x] = piece
    end

    def putable_piece?(direction:, piece_color:, x:, y:)
      return false unless at(x, y) == 0

      have_turnable_piece?(direction: direction, piece_color: piece_color, x: x, y: y)
    end

    def have_turnable_piece?(direction:, piece_color:, x:, y:)
      searcher = create_searcher(x, y)

      p = searcher.search(direction, 1)
      return false if p.nil? || p == 0 || p.send("#{piece_color}?")

      loop.with_index(2) do |_, distance|
        p = searcher.search(direction, distance)

        return false if p.nil? || p == 0

        return true if p.send("#{piece_color}?")
      end

      false
    end

    def pretty_print
      print "\e[2J"
      print "\e[1;1H"

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

    def at(x, y)
      @board.at(y)&.at(x)
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

    def create_searcher(x, y)
      Searcher.new(@board, x, y)
    end
  end
end
