class ConsoleReversi
  class Square
    attr_reader :piece

    def put(piece)
      @piece = piece
    end

    def empty?
      @piece.nil?
    end
  end
end
