module ConsoleBoard

  class Board

    class Table

      class Row

        attr_accessor :width

        def initialize attrs = {}
          attrs.each { |a, v| send(:"#{a}=", v) }
        end
      end
    end
  end
end

