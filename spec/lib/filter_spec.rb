require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PNG::Filters do
  before :each do
    @value = 64
    @index = 1
    @row = []
    @last_row = [0,0,0,0]
    @record_width = 4
  end
  
  it "should be able to encode / decode in a sane way for PAETH" do
    @filter_type = 4
    
    PNG::Filters.decode( @filter_type, @value, @index, @row, @last_row, @record_width ).should ==
    PNG::Filters.encode( @filter_type, @value, @index, @row, @last_row, @record_width )
  end
  
  it "should be able to encode / decode in a sane way for no filter" do
    @filter_type = 0
    
    PNG::Filters.decode( @filter_type, @value, @index, @row, @last_row, @record_width ).should ==
    PNG::Filters.encode( @filter_type, @value, @index, @row, @last_row, @record_width )
  end
end