
module Othello

  class Player

    attr_reader :color
    attr_accessor :passed

    def initialize othello, color
      @othello = othello
      @color = color
    end
  end

  class Person < Player

    def select
      ss = @othello.selections
      
      if ss.empty?
        @othello.view_info "Selection has not been found. You can't select."
        return
      end

      ss.each do |x, y|
        @othello.window[x, y] = "%d,%d" % [x, y]
      end

      @othello.view_info "Select (x,y)."

      x = @othello.gets_command('select X: ') or return
      y = @othello.gets_command('select Y: ') or return

      @othello.sync_stones_onto_window

      x, y = x.to_i, y.to_i

      if ss.include? [x, y]
        [x, y]
      else
        @othello.view_info("You can't put it at (#{x},#{y}). Do you want reselect? ")
        case @othello.gets_command("y/N [n]")
        when /^y/i
          select
        end

        nil
      end
    end
  end

  class Com < Player

    def select
      ss = @othello.selections
      ss.sample or (@othello.view_info("Selection has not been found."); nil)
    end
  end
end
