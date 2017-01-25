class Piece
  COLORS = {black: "\e[37;40m", white: "\e[30;47m"}

  def initialize(type:)
    @type = type
  end

  def pretty_print
    print "#{COLORS[@type.to_sym]} ⃝ "
  end
end
