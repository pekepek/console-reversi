require 'console_reversi/version'
require 'console_reversi/board'
require 'console_reversi/piece'

class ConsoleReversi
  class << self
    def game_start
      print "\e[2J"
      print "\e[1;1H"

      board = Board.new
      board.pretty_print
      # TODO 初期ボードを表示

      while game_finish?
        # TODO 白黒交互にユーザーが石を置いて、石をひっくり返す
        #      # できないといけないこと
        #        * カーソル移動
        #        * Enter で石を置く
        #        * 石がひっくり返る
      end

      # TODO 勝者判定
    end

    private

    def game_finish?
      # TODO ゲーム終了条件
    end
  end
end
