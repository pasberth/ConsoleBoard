module ConsoleBoard

  class Board

    class Rows

      include Enumerable

      def initialize board
        @board = board
      end

      def each &block
        @board.table.each_row &block
      end
    end
  end
end
