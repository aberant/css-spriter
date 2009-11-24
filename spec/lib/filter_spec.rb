require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PNG::Filters do
  before :each do
    @value = 64
    @index = 1
    @row = [0,64,0,0]
    @last_row = [0,32,0,0]
    @record_width = 4
  end

  it "should be able to convert between filters" do
    @filter_type = 4
    
    paeth =  PNG::Filters.encode( @filter_type, @value, @index, @row, @last_row, @record_width )
    output = PNG::Filters.convert( @filter_type, 0, paeth, @index, @row, @last_row, @record_width )
    output.should == @value
  end
end
