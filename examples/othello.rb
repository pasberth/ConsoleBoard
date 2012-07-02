$:.unshift File.dirname(__FILE__) + '/../lib'
$:.unshift File.dirname(__FILE__)

require 'console_board'

module Othello

  BLACK = :black
  WHITE = :white

  require 'othello/stone'
  require 'othello/player'
  require 'othello/othello_game'
end

begin
  Curses.init_screen
  othello = Othello::OthelloGame.new
  othello.start
ensure
  Curses.close_screen
end
