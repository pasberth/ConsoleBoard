# -*- coding: utf-8 -*-
module Othello

  include ConsoleWindow
  include ConsoleBoard

  class OthelloWindow < Container

    def initialize *args, &block
      super

      @othello = Game.new

      frames.on :main do
        @input.focus!
      end

      @info = create_sub(Window, 80, 1, 0, 9)
      @input = create_sub(Window, 80, 1, 0, 10)

      @input.frames.before :main do
        @input.text = "Input command: "
      end

      help = nil

      @input.frames.on :main do
        case @input.gets
        when /^put/i then @input.focus!(:put)
        when /^help\s+(.*)/i then @input.focus!(:help); help = $1
        when /^pass/i then @input.focus!(:pass)
        when /^exit/i then @input.unfocus!; self.unfocus!
        end
      end

      @input.frames.on :help do
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
        @input.unfocus!(:help)
      end

      @input.frames.on :pass do
        @othello.pass
      end

      selected = false

      @input.frames.on :put do |; ss, x, y|
        ss = @othello.turn_player.selections
        if ss.empty?
          @info.text = "Selection has not been found. You can't select."
          @input.unfocus!(:put)
        elsif selected
          selected = false

          x, y = @othello.board.board_cursor.x, @othello.board.board_cursor.y
          if ss.include? [x, y]
            @info.text = "You put it on (#{x}, #{y})."
            @othello.put(x, y)
            @input.unfocus!(:put)
          else
            @info.text = "You can't put it at (#{x}, #{y})."
          end
        else
          @othello.board.focus!(:select)
          selected = true
        end
      end
      
      self.components << @othello.board << @input << @info
    end
  end
end
