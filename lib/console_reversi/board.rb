class ConsoleReversi
  class Board
    def initialize
      @board = initialize_board
    end

    def put_piece!(piece:, x:, y:)
      @board[y][x] = piece
    end

    def putable_piece?(direction:, piece_color:, x:, y:)
      return false unless at(x, y).is_a?(Numeric)

      have_turnable_piece?(direction: direction, piece_color: piece_color, x: x, y: y)
    end

    def have_turnable_piece?(direction:, piece_color:, x:, y:)
      searcher = create_searcher(x, y)

      p = searcher.search(direction, 1)
      return false if !p.is_a?(Piece) || p.send("#{piece_color}?")

      loop.with_index(2) do |_, distance|
        p = searcher.search(direction, distance)

        return false if !p.is_a?(Piece)

        return true if p.send("#{piece_color}?")
      end

      false
    end

    def count_pieces(color:)
      @board.map {|col| col.count {|p| p != 0 && p.send("#{color}?") } }.inject(:+)
    end

    def pretty_print
      print "\e[2J"
      print "\e[1;1H"

      @board.each_with_index do |row, i|
        row.each_with_index do |p, j|
          print (i + j) % 2 == 0 ? "\e[46m" : "\e[47m"

          if p == 0
            print '　'
          elsif p == 1
            print "\e[37m〇"
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

    def plot_putable_point!(player)
      8.times do |i|
        8.times do |j|
          @board[j][i] = 1 if Searcher::DIRECTIONS.any? {|d| putable_piece?(direction: d, piece_color: player.piece_color, x: i, y: j) }
        end
      end
    end

    def refresh_putable_point!
      8.times do |i|
        8.times do |j|
          @board[j][i] = 0 if @board[j][i] == 1
        end
      end
    end

    def putable_positions
      @board.each_with_object([]).with_index {|(col, positions), i|
        col.each_with_index {|s, j|
          positions << [i, j] if s == 1
        }
      }
    end

    private

    def initialize_board
      board = 8.times.map { [0].cycle(8).to_a }

      board[3][3] = Piece.new(color: :black)
      board[3][4] = Piece.new(color: :white)
      board[4][3] = Piece.new(color: :white)
      board[4][4] = Piece.new(color: :black)

      board
    end

    def create_searcher(x, y)
      Searcher.new(@board, x, y)
    end
  end
end
