
module ConsoleBoard

  class Board

    class Cursor < Cursor

      def x
        window.table.each_row.
          take(window.board_cursor.x).
          map { |row| row[window.board_cursor.y].width }.
          inject(0, :+)
      end

      def y
        window.table.each_culumn.
          take(window.board_cursor.y).
          map { |cul| cul[window.board_cursor.x].height }.
          inject(0, :+)
      end
    end
  end
end
