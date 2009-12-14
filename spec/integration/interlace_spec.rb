require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "reading interlaced images" do
  before :all do
    @image_dir = File.join( File.dirname( __FILE__ ), "interlaced_images" )
  end
  
  before :each do
    @image = PNG::Image.open( @image_dir + "/interlaced-16x16-first-image.png" )
  end
  
  describe "sanity checks" do
    it "knows the images width" do
      @image.width.should == 16
    end
  
    it "knows the images height" do
      @image.height.should == 16
    end
  end
  
  it "can read the first sub-image from an interlaced image" do
    # should be the only colored pixels in the image.. with four different colors
    @image.to_image.should == [[255, 127, 63, 63, 127, 255], [33, 66, 99, 192, 255, 127]]
  end
end