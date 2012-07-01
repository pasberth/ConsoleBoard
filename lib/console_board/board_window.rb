require 'console_window'

module ConsoleBoard

  class BoardWindow < ConsoleWindow::Window

    require 'console_board/board_window/cell'

    include Enumerable

    def initialize horizontal_length, vertical_length, attritbes = {}
      super(attritbes)
      @all_cells = Array.new(vertical_length) { Array.new(horizontal_length) { Cell.new } }
      @horizontal_length = horizontal_length
      @vertical_length = vertical_length
    end

    # ====================
    # Attribute Methods
    # ====================

    attr_reader :horizontal_length
    attr_reader :vertical_length
    attr_reader :all_cells

    def format!
      xs = Array.new(vertical_length) { position.x }
      x = position.x
      y = position.y
      @all_cells.each do |cul|
        position.y = y
        cul.each_with_index do |cell, i|
          position.x = xs[i]
          print_rect cell.as_text

          if cell.collapse
            position.y += cell.height - 1
            xs[i] += cell.width - 1
          else
            position.y += cell.height
            xs[i] += cell.width
          end
        end
      end
      position.x = x
      position.y = y
    end

    def as_text
      format!
      super
    end

    def as_full_text
      format!
      super
    end

    def as_displayed_text
      format!
      super
    end

    def each &block
      if block_given?
        @all_cells.each do |cul|
          block.call cul.map(&:object)
        end
      else
        Enumerator.new(self, :each)
      end
    end

    def [] x, y
      @all_cells[x][y].object
    end

    # :call-seq:
    # self[x, y] = value   -> value
    def []= x, y, value
      @all_cells[x][y].object = value
    end
  end
end
