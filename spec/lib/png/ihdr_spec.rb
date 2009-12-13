require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe PNG::IHDR do
  before :each do
    @width = 40
    @height = 40
    @bit_depth = 8
    @color_type = 2
    
    @raw = [@width, @height, @bit_depth, @color_type, 0, 0, 0].pack("N2C5")
    @chunk = chunk( "IHDR", @raw )
    @header = PNG::IHDR.new_from_raw( @raw )
  end
  
  it "pulls out the width from the ihdr block" do
    @header.width.should == @width  
  end
  
  it "pulls out the height from the ihdr block" do
    @header.height.should == @height  
  end
  
  it "pulls out the bit depth from the ihdr block" do
    @header.depth.should == @bit_depth  
  end  
  
  it "pulls out the color type from the ihdr block" do
    @header.color_type.should == @color_type  
  end
  
  it "encodes it's self properly" do
    @header.encode.should == @raw
  end
  
  it "should be able to make a header chunk" do
    @header.to_chunk.should == @chunk
  end
end

describe "interlaced images" do
  before :each do
    @width = 40
    @height = 40
    @bit_depth = 8
    @color_type = 2
    @interlaced = 1
    
    @raw = [@width, @height, @bit_depth, @color_type, 0, 0, @interlaced].pack("N2C5")
    @chunk = chunk( "IHDR", @raw )
    @header = PNG::IHDR.new_from_raw( @raw )
  end
  
  it "can tell if it's interlaced" do
    @header.interlaced?.should be_true
  end
  
end