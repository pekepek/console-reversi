class ConsoleReversi
  class Player
    attr_accessor :piece_color

    def initialize(piece_color:)
      @piece_color = piece_color.to_sym
    end

    def put_piece_on!(board, x:, y:)
      board.put_piece!(piece: Piece.new(type: @piece_color), x: x, y: y)
    end

    def putable_piece?(board)
      8.times.any? {|i|
        8.times.any? {|j|
          Searcher::DIRECTIONS.any? {|d| board.putable_piece?(direction: d, piece_color: @piece_color, x: i, y: j) }
        }
      }
    end

    def turn_pieces!(board, x:, y:)
      searcher = Searcher.new(board, x, y)

      Searcher::DIRECTIONS.each do |direction|
        next unless board.have_turnable_piece?(direction: direction, piece_color: piece_color, x: x, y: y)

        loop.with_index(1) do |_, distance|
          pos = searcher.position(direction, distance)
          piece = board.at(pos[:x], pos[:y])

          break if piece.send("#{piece_color}?")

          put_piece_on!(board, x: pos[:x], y: pos[:y])
        end
      end
    end
  end
end
