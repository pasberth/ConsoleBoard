module ConsoleBoard

  class Board

    class Table

      require 'console_board/board/table/cell'

      def initialize board, table = []
        @board = board
        @table = table
      end

      attr_writer :width
      attr_writer :height

      def width
        @width or @table.length
      end

      def height
        @height or (max_row = @table.max) ? max_row.length : 0
      end

      def [] x, y
        if x < width && y < height
          (@table[x][y] ||= Cell.new).object
        else
          nil
        end
      end

      def []= x, y, val
        ((@table[x] ||= [])[y] ||= Cell.new).object = val
      end

      def each_row
        if block_given?
          width.times.map do |x|
            height.times.map do |y|
              (@table[x] ||= [])[y] ||= Cell.new
            end
          end.each do |row|
            yield row
          end

          self
        else
          Enumerator.new(self, :each_row)
        end
      end

      def each_culumn
        if block_given?
          height.times.map do |y|
            width.times.map do |x|
              (@table[x] ||= [])[y] ||= Cell.new
            end
          end.each do |cul|
            yield cul
          end
          self
        else
          Enumerator.new(self, :each_culumn)
        end
      end

      def as_string
        text = @board.text.clone
        each_culumn.with_index do |cul, y|
          cul.each_with_index do |cell, x|
            text.paste!(cell.as_string, cell.width * x, cell.height * y)
          end
        end

        text.as_displayed_string
      end

      alias as_displayed_string as_string
    end
  end
end
