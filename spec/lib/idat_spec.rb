require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PNG::IDAT do
  before :each do
    # it's just "Hello, World!" encoded
    @data = "x\234\363H\315\311\311\327Q\b\317/\312IQ\004\000\037\236\004j"
  end
  
  it "accepts compressed data" do
    @idat = PNG::IDAT.new
    
    @idat << @data
    
    @idat.encode.should == @data
  end
  
  it "can chunk its self" do
    @idat = PNG::IDAT.new
    @idat << @data
    @chunk = chunk( "IDAT", @idat.encode )
    
    @idat.to_chunk.should == @chunk
  end
  
  it "accepts uncompressed data for it's constructor" do
    @idat = PNG::IDAT.new( "Hello, World!".unpack("C*") )
    
    @idat.encode.should == @data
  end
end