require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "reading interlaced images" do
  before :all do
    @image_dir = File.join( File.dirname( __FILE__ ), "..", "interlaced_images" )
  end
  
  it "can read the first sub-image from an interlaced image" 
end