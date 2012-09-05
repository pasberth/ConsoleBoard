module ConsoleBoard

  class Board

    class Table

      class Culumn

        attr_accessor :height

        def initialize attrs = {}
          attrs.each { |a, v| send(:"#{a}=", v) }
        end
      end
    end
  end
end
