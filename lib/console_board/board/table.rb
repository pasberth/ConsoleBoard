module ConsoleBoard

  class Board

    class Table

      require 'console_board/board/table/cell'

      def initialize board, rows = []
        @board = board
        @rows = rows
        @culumns = width.times.map { |x| rows.map { |r| r[x] } }
        @as_str_buf = []
      end

      attr_writer :width
      attr_writer :height

      def width
        @width or @rows.length
      end

      def height
        @height or @culumns.length
      end

      def [] x, y
        if x < width && y < height
          if (@rows[x] ||= [])[y].nil? or (@culumns[y] ||= [])[x].nil?
            self[x, y] = nil
          end

          @rows[x][y].object
        else
          nil
        end
      end

      def []= x, y, val
        if (@rows[x] ||= [])[y].nil? or (@culumns[y] ||= [])[x].nil?
          @rows[x] ||= []
          @culumns[y] ||= []
          raise "!!!#{self.class}!!!" if @rows[x][y] or @culumns[y][x]
          Cell.new.tap do |cell|
            @rows[x][y] = cell
            @culumns[y][x] = cell
          end

        end

        @rows[x][y].object = val
      end

      def each_row
        return Enumerator.new(self, :each_row) unless block_given?

        width.times.zip(@rows) do |x, row|
          if row.nil?
            row = []
            @rows[x] = []
          end

          if row.length < height
            height.times do |y|
              self[x, y] ||= nil
            end
          end

          yield row
        end

        self
      end

      def each_culumn
        return Enumerator.new(self, :each_culumn) unless block_given?

        height.times.zip(@culumns) do |y, cul|
          if cul.nil?
            cul = []
            @culumns[y] = cul
          end

          if cul.length < width
            width.times do |x|
              self[x, y] ||= nil
            end
          end

          yield cul
        end

        self
      end

      def text
        text = @board.text.clone
        each_culumn.with_index do |cul, y|
          l = @as_str_buf[y] ||= []
          cul.each_with_index do |cell, x|
            if l[x] != (cell_as_s = cell.as_string)
              text.paste!(cell.as_string, cell.width * x, cell.height * y)
              l[x] = cell_as_s
            end
          end
        end

        text
      end

      def displayed_text
        text.displayed_text
      end

      def as_string
        text.as_displayed_string
      end

      alias as_displayed_string as_string
    end
  end
end
