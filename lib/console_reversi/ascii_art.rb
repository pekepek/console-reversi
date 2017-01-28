# frozen_string_literal: true

class ConsoleReversi
  module AsciiArt
    PASS = <<-'EOS'
 ____
|  _ \ __ _ ___ ___
| |_) / _` / __/ __|
|  __/ (_| \__ \__ \
|_|   \__,_|___/___/
    EOS

    FINISH = <<-'EOS'
 _____ _       _     _
|  ___(_)_ __ (_)___| |__
| |_  | | '_ \| / __| '_ \
|  _| | | | | | \__ \ | | |
|_|   |_|_| |_|_|___/_| |_|
    EOS

    WIN = <<-'EOS'
__        ___
\ \      / (_)_ __
 \ \ /\ / /| | '_ \
  \ V  V / | | | | |
   \_/\_/  |_|_| |_|
    EOS

    DRAW = <<-'EOS'
 ____
|  _ \ _ __ __ ___      __
| | | | '__/ _` \ \ /\ / /
| |_| | | | (_| |\ V  V /
|____/|_|  \__,_| \_/\_/
    EOS

    BLACK = <<-'EOS'
 ____  _            _
| __ )| | __ _  ___| | __
|  _ \| |/ _` |/ __| |/ /
| |_) | | (_| | (__|   <
|____/|_|\__,_|\___|_|\_\
    EOS

    WHITE = <<-'EOS'
__        ___     _ _
\ \      / / |__ (_) |_ ___
 \ \ /\ / /| '_ \| | __/ _ \
  \ V  V / | | | | | ||  __/
   \_/\_/  |_| |_|_|\__\___|
    EOS

    SPACE = ' '

    ONE = <<-'EOS'
 __
/_ |
 | |
 | |
 | |
 |_|
    EOS

    TWO = <<-'EOS'
 ___
|__ \
   ) |
  / /
 / /_
|____|
    EOS

    THREE = <<-'EOS'
 ____
|___ \
  __) |
 |__ <
 ___) |
|____/
    EOS

    FOUR = <<-'EOS'
 _  _
| || |
| || |_
|__   _|
   | |
   |_|
    EOS

    FIVE = <<-'EOS'
 _____
| ____|
| |__
|___ \
 ___) |
|____/
    EOS

    SIX = <<-'EOS'
   __
  / /
 / /_
| '_ \
| (_) |
 \___/
    EOS

    SEVEN = <<-'EOS'
 ______
|____  |
    / /
   / /
  / /
 /_/
    EOS

    EIGHT = <<-'EOS'
  ___
 / _ \
| (_) |
 > _ <
| (_) |
 \___/
    EOS

    NINE = <<-'EOS'
  ___
 / _ \
| (_) |
 \__, |
   / /
  /_/
    EOS

    ZERO = <<-'EOS'
  ___
 / _ \
| | | |
| | | |
| |_| |
 \___/
    EOS

    NUMBER_TO_ENGLISH = {
      1 => 'one',
      2 => 'two',
      3 => 'three',
      4 => 'four',
      5 => 'five',
      6 => 'six',
      7 => 'seven',
      8 => 'eight',
      9 => 'nine',
      0 => 'zero'
    }.freeze

    module_function

    def to_aa(*words, margin: nil)
      aas = words.map {|w|
        if w.is_a?(Numeric)
          number_to_aa(w)
        else
          const_get(w.upcase)
        end
      }.flatten

      splitted_aas = aas.map {|n| n.split("\n") }
      max_aa_len = splitted_aas.map {|aas| aas.count }.max

      max_aa_len.times.map {|i|
        spcase = "\e[#{margin}G" || ''

        spcase + splitted_aas.map {|aa|
          max_length = aa.map(&:size).max
          aa[i].to_s.ljust(max_length)
        }.join('')
      }.join("\n")
    end

    def number_to_aa(number)
      number.to_s.chars.map {|c| const_get(NUMBER_TO_ENGLISH[c.to_i].upcase) }
    end
  end
end
