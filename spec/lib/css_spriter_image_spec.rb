require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CssSpriter::Image do
  it "sets the name with the filename of the image" do
    image = CssSpriter::Image.from_file( File.dirname(__FILE__) + '/../images/lightening.png')
    image.name.should == 'lightening'
  end

  it "raises an error when the file is invalid" do
    expect {
      CssSpriter::Image.from_file( File.dirname(__FILE__) + '/../images/not_a.png')
    }.to raise_error(CssSpriter::Image::LoadingError)
  end
end