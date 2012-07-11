# -*- coding: utf-8 -*-
$:.unshift File.dirname(__FILE__) + '/../lib'
$:.unshift File.dirname(__FILE__)

require 'console_window'
require 'console_board'

module Othello

  require 'othello/helpers'
  require 'othello/stone'
  require 'othello/game'
  require 'othello/player'
  require 'othello/person'
  require 'othello/com'
  require 'othello/window'

  BLACK = :black
  WHITE = :white
end

include ConsoleWindow
include ConsoleBoard

screen = Screen.new
othello = screen.create_sub(Othello::OthelloWindow, 80, 20, 0, 0)
othello.focus!
screen.components << othello
screen.activate
