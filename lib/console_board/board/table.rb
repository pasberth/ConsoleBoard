require 'text_display'

module ConsoleBoard

  class Board

    class Table

      require 'console_board/board/table/cell'
      require 'console_board/board/table/row'
      require 'console_board/board/table/culumn'

      def initialize board, width = 0, height = 0
        @board = board
        @width = width
        @height = height
        @cells = Hash[*width.times.map.with_index { |x|
                        height.times.map.with_index { |y|
                          [[x, y], Cell.new] } }.flatten(2)]
        @rows = []
        @culumns = []
      end

      attr_accessor :width
      attr_accessor :height

      def [] x, y
        if x < width && y < height
          (@cells[ [x, y] ] ||= Cell.new).object
        else
          nil
        end
      end

      def []= x, y, val
        (@cells[ [x, y] ] ||= Cell.new).object = val
        modified x, y
      end

      def cell x, y
        @cells[ [x, y] ] ||= Cell.new
      end

      def row x
        @rows[x] ||= Row.new(width: 1)
      end

      def culumn y
        @culumns[y] ||= Culumn.new(height: 1)
      end

      def modified x, y
        return unless x < width && y < height

        posx = x.times.inject(0) { |r, x| r + self.row(x).width }
        posy = y.times.inject(0) { |r, y| r + self.culumn(y).height }
        row = self.row(x)
        cul = self.culumn(y)
        cell = self.cell(x, y)
        txt = TextDisplay::Text.new(cell.as_string).crop(0, 0, row.width, cul.height)
        base = TextDisplay::Text.new(@board.text.as_string)
        base.paste!(txt, posx, posy)
        @board.text = base
        true
      end

      def each_object
        return Enumerator.new(self, :each_object) unless block_given?

        each_cell do |cell, x, y|
          yield cell.object, x, y
        end
      end

      def each_cell
        return Enumerator.new(self, :each_cell) unless block_given?

        width.times do |x|
          height.times do |y|
            yield cell(x, y), x, y
          end
        end
      end

      def each_row
        return Enumerator.new(self, :each_row) unless block_given?

        width.times do |x|
          yield row(x)
        end

        self
      end

      def each_culumn
        return Enumerator.new(self, :each_culumn) unless block_given?

        height.times do |y|
          yield culumn(y)
        end

        self
      end
    end
  end
end
