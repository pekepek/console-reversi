require 'console_reversi/version'
require 'console_reversi/board'
require 'console_reversi/searcher'
require 'console_reversi/piece'
require 'console_reversi/player'
require 'console_reversi/ascii_art'

class ConsoleReversi
  def initialize
    @board = Board.new
    @black_player = Player.new(piece_color: :black)
    @white_player = Player.new(piece_color: :white)
  end

  def game_start
    @board.pretty_print

    loop.with_index do |_, turn_number|
      unless now_player(turn_number).putable_piece?(@board)
        if next_player(turn_number).putable_piece?(@board)
          print_pass

          next
        else
          break
        end
      end

      move_cursor do |key|
        if type_enter?(key)
          position = cursor_position
          board_position = {x: position[:x] / 2, y: position[:y] - 1}

          next if Searcher::DIRECTIONS.none? {|d| @board.putable_piece?(direction: d, piece_color: now_player(turn_number).piece_color, x: board_position[:x], y: board_position[:y]) }

          now_player(turn_number).put_piece_on!(@board, x: board_position[:x], y: board_position[:y])
          now_player(turn_number).turn_pieces!(@board, x: board_position[:x], y: board_position[:y])

          @board.pretty_print

          # NOTE back a cursor
          print "\e[#{position[:y]};#{position[:x]}H"

          break
        end
      end
    end

    print_result

    print "\e[8;1H"
  end

  private

  def now_player(turn_number)
    turn_number.even? ? @black_player : @white_player
  end

  def next_player(turn_number)
    now_player(turn_number) == @black_player ? @white_player : @black_player
  end

  def move_cursor(&block)
    while key = STDIN.getch
      # NOTE 一時的に ctrl c で中断できるようにしてる
      exit if key == "\C-c"

      if key == "\e" && STDIN.getch == "["
        key = STDIN.getch

        direction =
          case key
          when 'A', 'B'
            key
          when 'C', 'D'
            "2#{key}"
          else
            nil
          end

        print "\e[#{direction}" if direction
      end

      block.call(key)
    end
  end

  def cursor_position
    stdout = ''

    $stdin.raw do |stdin|
      $stdout << "\e[6n"
      $stdout.flush

      while (c = stdin.getc) != 'R'
        stdout << c
      end
    end

    positions = stdout.match /(\d+);(\d+)/

    {x: positions[2].to_i, y: positions[1].to_i}
  end

  def type_enter?(key)
    key == "\r"
  end

  def print_pass
    print "\e[2;1H"
    print AsciiArt::PASS

    sleep 1

    @board.pretty_print
    print "\e[1;1H"
  end

  def print_result
    print "\e[2;1H"
    print AsciiArt::FINISH

    sleep 1

    @board.pretty_print

    print "\e[1;1H"

    black_count = @board.count_pieces(color: :black)
    white_count = @board.count_pieces(color: :white)

    print ConsoleReversi::AsciiArt.to_aa('black', black_count, margin: 20)

    sleep 1

    print "\n"
    print ConsoleReversi::AsciiArt.to_aa('white', white_count, margin: 20)

    sleep 1

    @board.pretty_print

    result =
      if black_count > white_count
        ['black', 'win']
      elsif black_count == white_count
        ['draw']
      else
        ['white', 'win']
      end

    print "\e[2;1H"
    print ConsoleReversi::AsciiArt.to_aa(*result, margin: 20)
  end
end
