require 'console_reversi/version'
require 'console_reversi/board'
require 'console_reversi/searcher'
require 'console_reversi/piece'
require 'console_reversi/player'
require 'console_reversi/ascii_art'
require 'console_reversi/cursor_operatable'

class ConsoleReversi
  include CursorOperatable

  def initialize
    @board = Board.new
    @black_player = Player.new(piece_color: :black)
    @white_player = Player.new(piece_color: :white)
  end

  def game_start
    @board.plot_putable_point!(now_player(0))
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

          @board.refresh_putable_point!
          @board.plot_putable_point!(next_player(turn_number))
          @board.pretty_print

          # NOTE back a cursor
          print "\e[#{position[:y]};#{position[:x]}H"

          break
        end
      end
    end

    print_result

    print "\e[9;1H"
  end

  private

  def now_player(turn_number)
    turn_number.even? ? @black_player : @white_player
  end

  def next_player(turn_number)
    now_player(turn_number) == @black_player ? @white_player : @black_player
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
