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
        @width or @board.rows.map { |row| row.sort_by(&:width).last }.compact.inject(0) { |w, cell| w + cell.width }
      end

      def height
        @height or @board.culumns.map { |cul| cul.sort_by(&:height).last }.compact.inject(0) { |h, cell| h + cell.height }      
      end
    end
  end
end
