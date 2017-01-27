class ConsoleReversi
  class Piece
    COLORS = {black: "\e[37;40m", white: "\e[30;47m"}

    attr_accessor :type

    def initialize(type:)
      @type = type
    end

    def pretty_print
      print "#{COLORS[@type.to_sym]} ⃝ "
    end

    def black?
      @type == :black
    end

    def white?
      @type == :white
    end
  end
end
