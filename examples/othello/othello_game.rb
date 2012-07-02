
module Othello

  class OthelloGame

    INFO_AREA_LINE_N = 17
    COMMAND_LINE_N = 18
    BOARD_WIDTH = 8
    BOARD_HEIGHT = 8

    def initialize
    
      @window = ConsoleBoard::BoardWindow.new(BOARD_WIDTH, BOARD_HEIGHT, :curses_window => Curses.stdscr)

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

      @players = [Player.new(BLACK), Player.new(WHITE)]
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

    def view_info msg
      @window.lines[INFO_AREA_LINE_N] = msg
      @window.paint
    end

    def gets_command msg = "input command: "
      @window.lines[COMMAND_LINE_N] = msg
      @window.cursor.y = 18
      @window.cursor.x = msg.length
      @window.paint
      @window.gets
    end

    def command cmd
      case cmd
      when /^put/ then put
      when /^pass/ then pass
      end
    end

    def selections
      color = @turn_player.color
      selections = []

      @window.each_with_index do |cul, i|
        cul.each_with_index do |stone, j|
          next unless stone
          next if stone.color != color

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
        callback.call(i, j)
      end
    end

    def selection start_x, start_y, direction_x, direction_y

      flag = false
      tgt = nil

      trace(start_x, start_y, direction_x, direction_y) do |i, j|
        if @window[i, j].nil? or @window[i, j].color == @turn_player.color
          tgt = [i, j]
          break
        else
          flag = true
        end
      end

      flag ? tgt : nil
    end

    def select
      ss = selections

      ss.each do |x, y|
        @window[x, y] = "%d,%d" % [x, y]
      end

      x = gets_command('select X: ') or return
      y = gets_command('select Y: ') or return

      sync_stones_onto_window

      x, y = x.to_i, y.to_i

      if ss.include? [x, y]
        [x, y]
      else
        nil
      end
    end

    def _put start_x, start_y, direction_x, direction_y
      return if @window[start_x, start_y]

      trace(start_x, start_y, direction_x, direction_y) do |i, j|
        if @window[i, j] and @window[i, j].color != @turn_player.color
          @stones[i][j] = Stone.new(@turn_player.color)
        elsif @window[i, j].nil? or @window[i, j].color == @turn_player.color
          break
        end
      end
    end

    def put
      x, y = select.tap do |a|
        return unless a
      end

      _put(x, y, 1, 0)
      _put(x, y, 0, 1)
      _put(x, y, -1, 0)
      _put(x, y, 0, -1)
      _put(x, y, 1, 1)
      _put(x, y, -1, -1)
      _put(x, y, 1, -1)
      _put(x, y, -1, 1)

      @stones[x][y] = Stone.new(@turn_player.color)
      sync_stones_onto_window
      
      next_turn
    end

    def pass
      next_turn
    end

    def next_turn
      @turn_player = @players[@turn_player_n += 1] || @players[@turn_player_n = 0]
    end

    def start
      @window.paint

      while (cmd = gets_command) !~ /^exit/
        command(cmd)
        @window.paint
      end
    end
  end
end
