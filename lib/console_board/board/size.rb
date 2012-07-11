module ConsoleBoard

  class Board

    class Size

      def initialize board
        @board = board
      end

      def width= val
       # TODO:
      end

      def height= val
        # TODO:
      end

      def width
        @board.rows.map { |row| row.sort_by(&:width).last }.compact.inject(0) { |w, cell| w + cell.width }
      end

      def height
        @board.culumns.map { |cul| cul.sort_by(&:height).last }.compact.inject(0) { |h, cell| h + cell.height }      
      end
    end
  end
end
