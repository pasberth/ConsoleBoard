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

ConsoleWindow.start do
  othello = Othello::OthelloGame.new
  othello.start
end
