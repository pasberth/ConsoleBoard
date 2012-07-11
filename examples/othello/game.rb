# -*- coding: utf-8 -*-
module Othello

  class Game

    include Helpers

    attr_reader :board
    attr_reader :turn_player

    def initialize
      @board = Board.new(owner: self)
      @board = board
      @board.table.width = 8
      @board.table.height = 8
      @board.table[3, 3] = Stone.new(BLACK)
      @board.table[4, 4] = Stone.new(BLACK)
      @board.table[3, 4] = Stone.new(WHITE)
      @board.table[4, 3] = Stone.new(WHITE)

      @players = [Person.new(self, BLACK), Com.new(self, WHITE)]
      @turn_player = @players.shift
    end

    def next_turn
      @players << @turn_player
      @turn_player = @players.shift
      true
    end

    def pass
      next_turn
    end

    def put x, y
      trace_put(x, y, 1, 0)
      trace_put(x, y, 0, 1)
      trace_put(x, y, -1, 0)
      trace_put(x, y, 0, -1)
      trace_put(x, y, 1, 1)
      trace_put(x, y, -1, -1)
      trace_put(x, y, 1, -1)
      trace_put(x, y, -1, 1)
      @board.table[x, y] = Stone.new(@turn_player.color)

      next_turn
    end

    def trace_put start_x, start_y, direction_x, direction_y
      return if @board.table[start_x, start_y]

      targets = []
      trace(start_x, start_y, direction_x, direction_y) do |i, j|
        if @board.table[i, j].nil?
          break
        elsif @board.table[i, j].color != @turn_player.color
          targets << [i, j]
        elsif @board.table[i, j].color == @turn_player.color
          targets.each do |k, l|
            @board.table[k, l] = Stone.new(@turn_player.color)
          end; break
        end
      end
    end
  end
end
