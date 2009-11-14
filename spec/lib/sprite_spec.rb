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

  it "raises a pretty exception when the images are incompatible" do 
    taller_image = @builder.build( :width => 50, :height => 60, :name => "image")
    
    lambda do 
      @sprite.append taller_image
      @sprite.append @image1
    end.should raise_error(PNG::ImageFormatException)
  end

end
