require 'spec_helper'

describe ConsoleBoard::Board::Table do

  let(:window) { ConsoleBoard::Board.new(owner: nil) }
  subject { described_class.new(window) }

  its(:width) { should == 0 }
  its(:height) { should == 0 }
  its('each_row.to_a') { should be_empty }
  its('each_culumn.to_a') { should be_empty }
  its([0, 0]) { should be_nil }

  context do

    before do
      subject.width = 5
      subject.height = 2
    end

    its('each_row.to_a') { should have(5).items  }
    its('each_row.to_a') { should_not include nil  }

    its('each_culumn.to_a') { should have(2).items }
    its('each_culumn.to_a') { should_not include nil  }

    its(:width) { should == 5 }
    its(:height) { should == 2 }
  end

  context do

    example do
      subject.width = 5
      subject.height = 1

      5.times do |x|
        subject[x, 0] = '*'
      end

      window.as_string.should == "*****\n"
    end
  end

  context do

    example do
      subject.width = 5
      subject.height = 1

      5.times do |x|
        subject.row(x).width = 3
        subject[x, 0] = '  *'
      end

      window.as_string.should == "  *  *  *  *  *\n"
    end
  end
end
