$:.unshift File.dirname(__FILE__) + '/../lib'
require 'console_board'

begin
  Curses.init_screen
  window = ConsoleBoard::BoardWindow.new(9, 9, :curses_window => Curses.stdscr)
  window.all_cells.each do |cul|
    cul.each do |cell|
      cell.border.style = %w[ +---+ 
                              |   | 
                              +---+ ]
      cell.collapse = true
    end
  end

  window.paint
  Curses.getch
ensure
  Curses.close_screen
end
