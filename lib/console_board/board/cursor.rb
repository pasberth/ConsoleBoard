
module ConsoleBoard

  class Board

    class Cursor < Cursor

      def x
        window.table.each_row.
          take(window.board_cursor.x).
          inject(0) { |r, row| r + row.width }
      end

      def y
        window.table.each_culumn.
          take(window.board_cursor.y).
          inject(0) { |r, cul| r + cul.height }
      end
    end
  end
end
