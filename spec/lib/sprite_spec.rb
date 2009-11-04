require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PNG::Sprite do
  before :each do
    @sprite = PNG::Sprite.new
    
    @builder = ImageBuilder.new
    
    @image1 = @builder.build( :width => 50, :height => 50, :name => "image1")
    @image2 = @builder.build( :width => 50, :height => 50, :name => "image2")
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
  
  it "knows the location of each image in the sprite" do
    @sprite.merge_right( @image1 )
    @sprite.merge_right( @image2 )
    
    @sprite.locations[@image1.name.to_sym].should == {:x => -( @image1.width + @image2.width ), :width=> @image1.width } 
    @sprite.locations[@image2.name.to_sym].should == {:x => -( @image2.width ),  :width=> @image2.width } 
  end
    
end