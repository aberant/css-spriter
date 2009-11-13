require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PNG::Sprite do
  before :each do
    @sprite = PNG::Sprite.new
    @builder = ImageBuilder.new

    @image1 = @builder.build( :width => 50, :height => 50, :name => "image1")
    @image2 = @builder.build( :width => 50, :height => 50, :name => "image2")
  end

  it "can merge an image to the right" do
    @sprite.append( @image1 )
    @sprite.append( @image2 )

    @sprite.images.should == [@image1, @image2]
  end

  it "knows the location of each image in the sprite" do
    @sprite.append( @image1 )
    @sprite.append( @image2 )

    @sprite.locations[@image1.name.to_sym].should == {:x => -( 0 ), :width=> @image1.width } 
    @sprite.locations[@image2.name.to_sym].should == {:x => -( @image2.width ),  :width=> @image2.width } 
  end

end
