
module Othello

  class OthelloGame

    INFO_AREA_LINE_N = 17
    COMMAND_LINE_N = 18
    BOARD_WIDTH = 8
    BOARD_HEIGHT = 8

    attr_reader :window

    def initialize
    
      @screen = ConsoleWindow::Screen.new
      @window = ConsoleBoard::BoardWindow.new(BOARD_WIDTH, BOARD_HEIGHT, owner: @screen)
      @screen.components << @window

      @window.all_cells.each do |cul|
        cul.each do |cell|
          cell.border.style = %w[ +---+ 
                                  |   | 
                                  +---+ ]
          cell.collapse = true
        end
      end

      @stones = Array.new(BOARD_WIDTH) { Array.new(BOARD_HEIGHT) { nil } }
      @stones[3][3] = Stone.new(:black)
      @stones[4][4] = Stone.new(:black)
      @stones[3][4] = Stone.new(:white)
      @stones[4][3] = Stone.new(:white)

      sync_stones_onto_window

      @window.lines[INFO_AREA_LINE_N] = 'Info Area'
      @window.lines[COMMAND_LINE_N] = 'Command line'

      @players = [Person.new(self, BLACK), Com.new(self, WHITE)]
      @turn_player = @players.first
      @turn_player_n = 0
    end

    def sync_stones_onto_window
      @stones.each_with_index do |cul, i|
        cul.each_with_index do |stone, j|
          @window[i, j] = stone
        end
      end
    end

    def next_turn
      @turn_player = @players[@turn_player_n += 1] || @players[@turn_player_n = 0]
      view_info "next turn is #{@turn_player.color}."
    end

    # ====================
    # View 
    # ====================

    def view_info msg
      @window.lines[INFO_AREA_LINE_N] = msg
      @screen.paint
    end

    def gets_command msg = "input command: "
      @window.lines[COMMAND_LINE_N] = msg
      @window.cursor.y = 18
      @window.cursor.x = msg.length
      @screen.paint
      @window.gets
    end

    # ====================
    # Command
    # ====================


    def command cmd
      case cmd
      when /^help\s+(.*)/ then help $1
      when /^put/ then put
      when /^pass/ then pass
      end
    end

    def help cmd
      case cmd
      when /^put/
        view_info "Put a stone onto the board."
      when /^pass/
        view_info "Pass the turn."
      when /^exit/
        view_info "Exit the game."
      else
        view_info "Type 'help <command>', put a stone onto the board."
      end
    end

    def pass
      @turn_player.passed = true
      next_turn
    end

    def put
      (x, y = select) or return

      trace_put(x, y, 1, 0)
      trace_put(x, y, 0, 1)
      trace_put(x, y, -1, 0)
      trace_put(x, y, 0, -1)
      trace_put(x, y, 1, 1)
      trace_put(x, y, -1, -1)
      trace_put(x, y, 1, -1)
      trace_put(x, y, -1, 1)

      @stones[x][y] = Stone.new(@turn_player.color)
      sync_stones_onto_window

      @turn_player.passed = false      
      next_turn
    end

    def trace_put start_x, start_y, direction_x, direction_y
      return if @stones[start_x][start_y]

      targets = []
      trace(start_x, start_y, direction_x, direction_y) do |i, j|
        if @stones[i][j].nil?
          break
        elsif @stones[i][j].color != @turn_player.color
          targets << [i, j]
        elsif @stones[i][j].color == @turn_player.color
          targets.each do |k, l|
            @stones[k][l] = Stone.new(@turn_player.color)
          end

          break
        end
      end
    end

    def select
      @turn_player.select
    end

    # ====================
    # Helpers
    # ====================

    def selections
      selections = []

      @stones.each_with_index do |cul, i|
        cul.each_with_index do |stone, j|
          next unless stone
          next if stone.color != @turn_player.color

          selections << selection(i, j, 1, 0)
          selections << selection(i, j, 0, 1)
          selections << selection(i, j, -1, 0)
          selections << selection(i, j, 0, -1)
          selections << selection(i, j, 1, 1)
          selections << selection(i, j, -1, -1)
          selections << selection(i, j, 1, -1)
          selections << selection(i, j, -1, 1)
        end
      end

      selections.compact.uniq
    end

    def selection start_x, start_y, direction_x, direction_y

      flag = false
      tgt = nil

      trace(start_x, start_y, direction_x, direction_y) do |i, j|
        if @stones[i][j].nil?
          tgt = [i, j]
          break
        elsif @stones[i][j].color == @turn_player.color
          break
        elsif @stones[i][j].color != @turn_player.color
          flag = true
        end
      end

      flag ? tgt : nil
    end

    def trace start_x, start_y, direction_x, direction_y, &callback
      x = if direction_x > 0
            (start_x + direction_x).upto(7)
          elsif direction_x < 0
            (start_x + direction_x).downto(0)
          else
            [start_x].cycle
          end

      y = if direction_y > 0
            (start_y + direction_y).upto(7)
          elsif direction_y < 0
            (start_y + direction_y).downto(0)
          else
            [start_y].cycle
          end

      x.zip(y) do |i, j|
        return unless i and j
        callback.call(i, j)
      end
    end

    def start
      @screen.paint

      while (cmd = gets_command) !~ /^exit/
        break fin! if @players.all? &:passed
        command(cmd)
        @screen.paint
      end
    end

    def fin!
      msg = @stones.to_a.flatten.compact.group_by(&:color).map { |color, stones| "%s has %d stones." % [color, stones.count] }.join(" ")
      view_info "Game set. #{msg}"
      gets_command "Press any key, finish the game."
    end
  end
end
