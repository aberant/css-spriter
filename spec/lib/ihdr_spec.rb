require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PNG::IHDR do
  before :each do
    @width = 40
    @height = 40
    @bit_depth = 8
    @color_type = 2
    
    @raw = [@width, @height, @bit_depth, @color_type, 0, 0, 0].pack("N2C5")
  end
  
  it "pulls out the width from the ihdr block" do
    @header = PNG::IHDR.new_from_raw( @raw )
    @header.width.should == @width  
  end
  
  it "pulls out the height from the ihdr block" do
    @header = PNG::IHDR.new_from_raw( @raw )
    @header.height.should == @height  
  end
  
  it "pulls out the bit depth from the ihdr block" do
    @header = PNG::IHDR.new_from_raw( @raw )
    @header.depth.should == @bit_depth  
  end  
  
  it "pulls out the color type from the ihdr block" do
    @header = PNG::IHDR.new_from_raw( @raw )
    @header.color_type.should == @color_type  
  end
end