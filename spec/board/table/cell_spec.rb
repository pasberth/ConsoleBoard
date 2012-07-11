require 'spec_helper'

describe ConsoleBoard::Board::Table::Cell do

  its(:as_string) { should have(2).characters }
  its(:width) { should == 1 }
  its(:height) { should == 1 }

  context do

    before do
      subject.width = 3
      subject.height = 3
    end

    its(:width) { should == 3 }
    its(:height) { should == 3 }
    its(:as_string) { should have(12).characters }
  end
end
