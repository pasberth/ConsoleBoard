require 'spec_helper'

describe ConsoleBoard::Board::Table do

  let(:window) { ConsoleBoard::Board.new(owner: nil) }
  subject { described_class.new(window) }

  its(:width) { should == 0 }
  its(:height) { should == 0 }
  its(:as_string) { should == "" }
  its(:as_displayed_string) { should == "" }
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

    before do
      subject.width = 5
      subject.height = 1

      subject.each_culumn do |culumn|
        culumn.each { |cell| cell.object = '*' }
      end
    end

    its(:as_string) { should == "*****\n" }
  end

  context do

    before do
      subject.width = 5
      subject.height = 1
      subject.each_culumn do |cul|
        cul.each { |cell| cell.width = 3; cell.object = '*' }
      end
    end

    its(:as_string) { should == "  *  *  *  *  *\n" }
  end
end
