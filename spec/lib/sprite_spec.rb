require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Sprite do
  before :each do
    @sprite = Sprite.new
    @builder = ImageBuilder.new

    #TODO - We should just create ImageData objects here
    @image1 = @builder.build( :width => 50, :height => 50, :name => "image1").to_image
    @image2 = @builder.build( :width => 50, :height => 50, :name => "image2").to_image
  end

  it "can merge an image to the right" do
    @sprite.append( @image1 )
    @sprite.append( @image2 )

    @sprite.images.should == [@image1, @image2]
  end

  it "knows the location of each image in the sprite" do
    @sprite.append( @image1 )
    @sprite.append( @image2 )

    @sprite.locations[@image1.name.to_sym].should == {:x => -( 0 ), :width=> @image1.width, :height => @image1.height }
    @sprite.locations[@image2.name.to_sym].should == {:x => -( @image2.width ),  :width=> @image2.width, :height => @image2.height }
  end

  it "knows the height of the tallest image" do
    max_height = 70

    @image3 = @builder.build( :width => 50, :height => max_height, :name => "image3")

    @sprite.append( @image1 )
    @sprite.append( @image3 )

    @sprite.max_height.should == max_height
  end

end
