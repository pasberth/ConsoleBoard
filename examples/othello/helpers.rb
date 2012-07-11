module Othello

  module Helpers

    def trace start_x, start_y, direction_x, direction_y, &callback
      x = if direction_x > 0
            (start_x + direction_x).upto(7)
          elsif direction_x < 0
            (start_x + direction_x).downto(0)
          else
            [start_x].cycle
          end
      
      y = if direction_y > 0
          (start_y + direction_y).upto(7)
        elsif direction_y < 0
          (start_y + direction_y).downto(0)
        else
          [start_y].cycle
        end

      x.zip(y) do |i, j|
        return unless i and j
        callback.call(i, j)
      end
    end
  end
end
