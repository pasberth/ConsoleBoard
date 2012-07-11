module ConsoleBoard

  class Board

    class BoardCursor < Struct.new(:window, :x, :y)

      def up!
        self.y > min_y ? (self.y -= 1; true) : false
      end

      def left!
        self.x > min_x ? (self.x -= 1; true) : false
      end

      def right!
        self.x < max_x ? (self.x += 1; true) : false
      end
      
      def down!
        self.y < max_y ? (self.y += 1; true) : false
      end

      def min_x
        0
      end

      def min_y
        0
      end

      def max_x
        window.table.width - 1
      end

      def max_y
        window.table.height - 1
      end
    end
  end
end
