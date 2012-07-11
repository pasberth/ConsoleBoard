module ConsoleBoard

  class Board

    class Culumns

      include Enumerable

      def initialize board
        @board = board
      end

      def each &block
        @board.table.each_culumn &block
      end
    end
  end
end
