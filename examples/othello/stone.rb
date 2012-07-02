
module Othello

  class Stone

    attr_reader :color

    def initialize color
      @color = color
    end

    def to_s
      case @color
      when BLACK then '@'
      when WHITE then 'O'
      end
    end
  end
end
