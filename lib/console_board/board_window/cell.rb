require 'console_board/board_window'

module ConsoleBoard

  class BoardWindow::Cell
    
    attr_accessor :object
    attr_accessor :border
    attr_accessor :width
    attr_accessor :height
    attr_accessor :collapse

    def initialize
      @border = Border.new('+--+', '|', '|', '+--+')
    end

    def width
      return @width if @width
      if border.top.length != border.bottom.length
        raise "auto inference of the width faild.\n" +
              "#{border.top.inspect} != #{border.bottom.inspect}" 
      end
      @width = border.top.length
    end

    def height
      return @height if @height
      if (h1 = border.left.split("\n").length) != border.right.split("\n").length
        raise "auto inference of the height faild.\n" +
              "#{border.left.inspect} != #{border.right.inspect}"       
      elsif (h2 = border.top.split("\n").length) != border.bottom.split("\n").length
        raise "auto inference of the height faild.\n" +
              "#{border.top.inspect} != #{border.bottom.inspect}"
      end
      @height = h1 + (h2 * 2)
    end
    
    def cell_as_line
      return @cell_as_line if @cell_as_line and
                              @object_to_s == object.to_s
      objw = width - (border.left.length + border.right.length)
      @object_to_s = object.to_s
      @cell_as_line = [border.left, "%#{objw}s" % object.to_s[0 .. objw], border.right].join
    end

    def lines
      [ border.top,
        cell_as_line,
        border.bottom
      ]
    end

    def as_text
      lines.join("\n")
    end
  end

  class BoardWindow::Cell::Border < Struct.new :top, :left, :right, :bottom
    def style= style
      self.top, self.left, self.right, self.bottom = style
    end
  end
end
