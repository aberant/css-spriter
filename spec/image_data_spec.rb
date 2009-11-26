require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Spittle::ImageData do 
before do 
    data = [[1,2,3], 
            [4,5,6]]
    @id = Spittle::ImageData.new(:scanline_width => 10, :pixel_width => 4, :data => data)
end

  it "has scanline width and pixel width attributes" do 
    @id.scanline_width.should == 10
    @id.pixel_width.should == 4
  end

  it "can give you any arbitrary row in the data set" do 
    @id[0].should == [1,2,3]
    @id.scanline(0).should == [1,2,3]
  end

  it "has an empty array by default" do 
    id = Spittle::ImageData.new
    id.empty?.should be_true
  end

  it "should return nil when asked for an index that doesn't exist" do 
    id = Spittle::ImageData.new
    id[0].should be_nil
  end

  it "can be assigned a row" do 
    @id[0] = [1,2,3]
    @id[0].should == [1,2,3]
  end

  it "behaves like an array" do 

    @id << [1,2,3]
    @id.last.should == [1,2,3]

    @id.size.should == 3
  end

  it "will return the last scanline given a current index" do 
    @id.last_scanline(1).should == [1,2,3]
  end

  it "always transforms data to Row objects" do 
    @id
  end
end
