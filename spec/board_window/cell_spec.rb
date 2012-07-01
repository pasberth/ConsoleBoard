require 'spec_helper'

describe ConsoleBoard::BoardWindow::Cell do

  describe "Set all attributes" do
    before do
      subject.object = 'A'
      subject.border.top = '*--*'
      subject.border.left = '|'
      subject.border.right = '|'
      subject.border.bottom = '*--*'
      subject.collapse = false
    end

    its(:width) { should == 4 }
    its(:height) { should == 3 }
    its(:as_text) { should == "*--*\n"  "| A|\n"  "*--*" }
  end
end
