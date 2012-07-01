
require 'spec_helper'

describe ConsoleBoard::BoardWindow do

  subject { described_class.new(5, 5)  }

  context do

    before do
      subject[0, 0] = 'A'
    end

    its(:as_text) { should include 'A' }
    its([0, 0]) { should == 'A' }
  end

  describe "Shogi" do

    subject { described_class.new(9, 9) }

    before do
      subject.all_cells.each do |cul|
        cul.each do |cell|
          cell.border.style = %w[ +--+ 
                                  |  | 
                                  +--+ ]
          cell.collapse = true
        end
      end
    end

    its(:as_text) { should == <<-A.chomp }
+--+--+--+--+--+--+--+--+--+
|  |  |  |  |  |  |  |  |  |
+--+--+--+--+--+--+--+--+--+
|  |  |  |  |  |  |  |  |  |
+--+--+--+--+--+--+--+--+--+
|  |  |  |  |  |  |  |  |  |
+--+--+--+--+--+--+--+--+--+
|  |  |  |  |  |  |  |  |  |
+--+--+--+--+--+--+--+--+--+
|  |  |  |  |  |  |  |  |  |
+--+--+--+--+--+--+--+--+--+
|  |  |  |  |  |  |  |  |  |
+--+--+--+--+--+--+--+--+--+
|  |  |  |  |  |  |  |  |  |
+--+--+--+--+--+--+--+--+--+
|  |  |  |  |  |  |  |  |  |
+--+--+--+--+--+--+--+--+--+
|  |  |  |  |  |  |  |  |  |
+--+--+--+--+--+--+--+--+--+
   A
  end
end
