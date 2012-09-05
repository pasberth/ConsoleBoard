module ConsoleBoard

  class Board

    class Size

      def initialize board
        @board = board
      end

      def width= val
        @width = val
      end

      def height= val
        @height = val
      end

      def width
        @width or @board.rows.inject(0) { |r, row| r + row.width }
      end

      def height
        @height or @board.culumns.inject(0) { |r, cul| r + cul.height }
      end
    end
  end
end
