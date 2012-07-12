# -*- coding: utf-8 -*-
module Othello

  include ConsoleWindow
  include ConsoleBoard

  class OthelloWindow < Container

    def initialize *args, &block
      super

      @board = ConsoleBoard::Board.new(owner: self)
      @othello = Game.new(@board)

      frames.on :main do
        unfocus! :main
        focus! :command
      end

      @info = create_sub(ConsoleWindow::Window, 80, 1, 0, 9)
      @input = create_sub(ConsoleWindow::Window, 80, 1, 0, 10)

      frames.group :command do |g|
        g.before :main do
          @input.text = "Input command: "
        end

        g.on :main do
          case @input.gets
          when /^put/i then g.focus!(:put) 
          when /^pass/i then g.focus!(:pass)
          when /^help\s+(.*)/i then g.focus!(:help, $1)
          when /^exit/i then g.unfocus!
          end
        end

        g.on :help do |help|
          case help
          when /^put/i
            @info.text = "Put a stone onto the board."
          when /^pass/i
            @info.text = "Pass the turn."
          when /^exit/i
            @info.text = "Exit the game."
          else
            @info.text = "Type 'help <cmd>' (cmd is one of 'put', 'pass', 'exit'.)"
          end
          g.unfocus!(:help)
        end

        g.on :pass do
          @othello.pass
          g.unfocus!(:pass)
        end

        g.group :put do |put|

          put.on :main do |; ss|
            ss = @othello.turn_player.selections

            if ss.empty?
              @info.text = "Selection has not been found. You can't select."
              put.unfocus!
            else
              put.focus!(:put!, ss)
              @board.focus!(:select)
            end
          end

          put.on :put! do |ss|
            x, y = @board.board_cursor.x, @board.board_cursor.y

            if ss.include? [x, y]
              @info.text = "You put it on (#{x}, #{y})."
              @othello.put(x, y)
              put.unfocus!
              g.focus!(:next_turn)
            else
              @info.text = "You can't put it at (#{x}, #{y})."
              put.unfocus!(:put!)
            end
          end
        end

        g.on :next_turn do
          @info.text = "Next turn is #{@othello.turn_player.color}"
          g.unfocus! :next_turn
        end
      end

      self.components << @othello.board << @input << @info
    end
  end
end
