class ConsoleReversi
  module CursorOperatable
    def move_cursor(&block)
      while key = STDIN.getch
        # NOTE enable to cancel a game by ctrl-c
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
  end
end
