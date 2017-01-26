require 'console_reversi/version'
require 'console_reversi/board'
require 'console_reversi/piece'
require 'console_reversi/player'

class ConsoleReversi
  def initialize
    @board = Board.new
    @black_player = Player.new(piece_color: :black)
    @white_player = Player.new(piece_color: :white)
  end

  def game_start
    @board.pretty_print
    # TODO 初期ボードを表示

    loop.with_index do |_, turn_number|
      # TODO 石が置けない場合 pass

      move_cursor do |key|
        if type_enter?(key)
          position = cursor_position

          now_player(turn_number).put_piece_on!(@board, x: position[:x] / 2, y: position[:y] - 1)

          @board.pretty_print
          # NOTE back a cursor
          print "\e[#{position[:y]};#{position[:x]}H"

          break
        end
      end

      # TODO 石がひっくり返る

      break if game_finish?
    end

    # TODO 勝者判定
  end

  private

  def game_finish?
    # TODO ゲーム終了条件
    # NOTE 一時的に ctrl c で中断できるようにしてる
    STDIN.getch == "\C-c"
  end

  def now_player(turn_number)
    turn_number.even? ? @black_player : @white_player
  end

  def move_cursor(&block)
    while key = STDIN.getch
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
end
