class ConsoleReversi
  class Piece
    COLORS = {black: "\e[30m", white: "\e[37m"}

    attr_accessor :color

    def initialize(color:)
      @color = color
    end

    def pretty_print
      print "#{COLORS[@color.to_sym]}⬤️⃝ "
    end

    def black?
      @color == :black
    end

    def white?
      @color == :white
    end
  end
end
