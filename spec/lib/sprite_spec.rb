require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PNG::Sprite do
  before :each do
    @sprite = PNG::Sprite.new
    
    @builder = ImageBuilder.new
    
    @image1 = @builder.build( :width => 50, :height => 50)
    @image2 = @builder.build( :width => 50, :height => 50)
  end
  
  it "can merge an image to the right" do
    @sprite.merge_right( @image1 )
    @sprite.merge_right( @image2 )
    
    @sprite.images.should == [@image1, @image2]
  end
  
  it "can merge an image to the left" do
    @sprite.merge_left( @image1 )
    @sprite.merge_left( @image2 )
    
    @sprite.images.should == [@image2, @image1]
  end
  
  it "can output sprites by delegating to the images" do
    @image3 = @builder.build( :width => 100, :height => 50)
    
    @sprite.merge_right( @image1 )
    @sprite.merge_right( @image2 )
    
    @image1.should_receive( :merge_right ).with( @image2 ).and_return( @image3 )
    @image3.should_receive( :write ).with( "test.png" )
    
    @sprite.write( 'test.png' )
  end
end