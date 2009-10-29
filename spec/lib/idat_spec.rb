require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PNG::IDAT do

  it "accepts compressed data" do
    @data = "compressed png data"
    
    Zlib::Inflate.should_receive( :inflate ).with( @data ).and_return( "uncompressed data" )
    
    PNG::IDAT.new_from_compressed( @data )
  end
  
  
  it "encodes its self" do
    @data = "this is raw data"
    @idat = PNG::IDAT.new( @data )
    
    @idat.encode.should == Zlib::Deflate.deflate( @data )
  end
  
  it "can chunk its self" do
    @data = "this is raw data"
    @idat = PNG::IDAT.new( @data )
    @chunk = chunk( "IDAT", @idat.encode )
    
    @idat.to_chunk.should == @chunk
  end
end