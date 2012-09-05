require 'paint'

module ConsoleBoard

  class Board

    class Table

      class Cell

        def initialize object = nil, as_string_method = :as_string
          @objects = { 0 => DecoratedObject.new(object, as_string_method) }
        end

        def object
          @objects[0].object
        end

        def object= val
          @objects[0].object = val
        end

        def as_string
          @objects[0].as_string
        end
      end

      class DecoratedObject

        def initialize object = nil, as_string_method = :as_string
          @object = object
          @as_string_method = as_string_method
        end

        attr_accessor :object
        attr_accessor :color

        def as_string
          str = (object.respond_to?(@as_string_method) ? object.send(@as_string_method) : object.to_s)
          return @as_str if @str == str

          @str = str
          @as_str = Paint[str, *[color].compact]
        end
      end
    end
  end
end
