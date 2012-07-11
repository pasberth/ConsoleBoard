module Othello
  class Stone

    attr_reader :color

    def initialize color
      @color = color
    end

    def as_string
      case @color
      when BLACK then '@'
      when WHITE then 'O'
      end
    end
  end
end
