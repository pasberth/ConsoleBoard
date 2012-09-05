module Othello

  class Player

    include Helpers

    attr_reader :color

    def initialize othello, color
      @othello = othello
      @color = color
    end

    def selection start_x, start_y, direction_x, direction_y

      flag = false
      tgt = nil

      trace(start_x, start_y, direction_x, direction_y) do |i, j|
        if @othello.board.table[i, j].nil?
          tgt = [i, j]
          break
        elsif @othello.board.table[i, j].color == self.color
          break
        elsif @othello.board.table[i, j].color != self.color
          flag = true
        end
      end

      flag ? tgt : nil
    end

    def selections
      selections = []

      @othello.board.table.each_object do |stone, i, j|
        next unless stone
        next if stone.color != self.color

        selections << selection(i, j, 1, 0)
        selections << selection(i, j, 0, 1)
        selections << selection(i, j, -1, 0)
        selections << selection(i, j, 0, -1)
        selections << selection(i, j, 1, 1)
        selections << selection(i, j, -1, -1)
        selections << selection(i, j, 1, -1)
        selections << selection(i, j, -1, 1)
      end

      selections.compact.uniq
    end
  end
end
