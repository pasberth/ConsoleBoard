module ConsoleBoard

  class Board

    class Table

      class Cell

        def initialize object = nil
          @object = object
          @width = 1
          @height = 1
        end

        attr_accessor :object
        attr_accessor :width
        attr_accessor :height

        def as_string
          str = (@object.respond_to?(:as_string) ? @object.as_string : @object.to_s)

          return @as_str if @str == str
          @str = str

          @as_str = 1.upto(height).map do |i|
           if i == (height.to_f / 2).ceil
             "%*s" % [width, str]
           else
             ' ' * width
           end
          end.join("\n") + "\n"
        end
      end
    end
  end
end
