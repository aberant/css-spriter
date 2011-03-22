require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CssSpriter::Image do
  it "sets the name with the filename of the image" do
    image = CssSpriter::Image.from_file( File.dirname(__FILE__) + '/../images/lightening.png')
    image.name.should == 'lightening'
  end
end