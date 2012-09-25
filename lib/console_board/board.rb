require 'console_window/window'

module ConsoleBoard

  class Board < ConsoleWindow::Window

    require 'console_board/board/size'
    require 'console_board/board/cursor'
    require 'console_board/board/board_cursor'
    require 'console_board/board/table'
    require 'console_board/board/rows'
    require 'console_board/board/culumns'

    def initialize *args, &block
      super

# TODO:
      frames.on :select do |cancel_keys = [27.chr]|
        case key = getc
        when *cancel_keys
          unfocus!(:select, return_value: [key, board_cursor.x, board_cursor.y])
        when Curses::Key::RIGHT then board_cursor.right!
        when Curses::Key::LEFT then board_cursor.left!
        when Curses::Key::UP then board_cursor.up!
        when Curses::Key::DOWN then board_cursor.down!
        end
      end
    end

    AUTO = nil

    def default_attributes
      super.merge( {
                     width:         AUTO,
                     height:        AUTO,
                     size:          Size.new(self),
                     cursor:        Cursor.new(self, 0, 0),
                     board_cursor:  BoardCursor.new(self, 0, 0),
                     table:         Table.new(self),
                     rows:          Rows.new(self),
                     culumns:       Culumns.new(self)
                   } )
    end

    attr_accessor :size
    attr_accessor :cursor
    attr_accessor :board_cursor
    attr_accessor :table
    attr_accessor :rows
    attr_accessor :culumns
  end
end
