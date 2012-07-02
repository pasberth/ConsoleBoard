$:.unshift File.dirname(__FILE__) + '/../lib'
require 'console_board'

begin
  Curses.init_screen
  screen = ConsoleWindow::Screen.new
  window = ConsoleBoard::BoardWindow.new(9, 9)
  window.all_cells.each do |cul|
    cul.each do |cell|
      cell.border.style = %w[ +---+ 
                              |   | 
                              +---+ ]
      cell.collapse = true
    end
  end

  screen.components << window
  screen.paint
  Curses.getch
ensure
  Curses.close_screen
end
