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

        def as_string
          (object.respond_to?(@as_string_method) ? object.send(@as_string_method) : object.to_s)
        end
      end
    end
  end
end
