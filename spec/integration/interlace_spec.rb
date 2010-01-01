require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


#Interlaced Image color breakdown
#
# pass 1: (1,1,1)
# pass 2: (42,42,42)
# pass 3: (103, 103, 0)
# pass 4: (104, 0, 0)
# pass 5: (0, 105, 0)
# pass 6: (0, 0, 106)
# pass 6: (207, 207)

describe "reading interlaced images" do
  before do
    begin
      @image_dir = File.join( File.dirname( __FILE__ ), "interlaced_images" )
      @image = PNG::Image.open( @image_dir + "/interlaced-16x16.png" )
      @result = @image.to_image
    rescue Exception => e
      puts e.backtrace.join("\n")
      raise e
    end
  end

  describe "sanity checks" do
    it "knows the images width" do
      @image.width.should == 16
    end

    it "knows the images height" do
      @image.height.should == 16
    end
  end

  describe "pass extraction" do
    it "can read the first sub-image from an interlaced image" do
      @result.fetch_pixel(0).should == [1,1,1]
      @result.fetch_pixel(7).should == [1,1,1]

      @result.fetch_pixel(0, 7).should == [1,1,1]
      @result.fetch_pixel(7, 7).should == [1,1,1]
    end

    it "can read the second sub-image" do 
      @result.fetch_pixel(3).should == [42,42,42]
      @result.fetch_pixel(11).should == [42,42,42]

      @result.fetch_pixel(3, 7).should == [42,42,42]
      @result.fetch_pixel(11, 7).should == [42,42,42]
    end
  end
end
