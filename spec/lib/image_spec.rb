require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PNG::Image do
  before :each do
    @sprite = Sprite.new
    
    @builder = ImageBuilder.new
    
    # 0 is the filter type for the row, then an RGB triplet since builder defaults to color type 2
    @image1 = @builder.build( :width => 1, :height => 1, :name => "image1", :data => [0,1,2,3] )
    @image2 = @builder.build( :width => 1, :height => 1, :name => "image2", :data => [0,4,5,6] )
  end

  it "can merge left" do
    result = @image1.to_image.merge_left @image2.to_image
    
    result.should == [[4,5,6,1,2,3]]
  end
  
  it "can encode the rows with filter 0" do
    @image1.filter_encoded_rows(0).should == [[0, 1, 2, 3]]
  end
  
  
  it "can encode the rows with filter 1" do
    image = @builder.build( :width => 2, :height => 1, :name => "image1", :data => [0,1,2,3,4,5,6] )

    # filter byte of 1
    # first byte of pixel 2 - pixel 1 is 3
    # second byte of pixel 2 - pixel 1 is 3.. etc
    image.filter_encoded_rows(1).should == [[1, 1, 2, 3, 3, 3, 3]]
  end
  
  it "can encode the rows with filter 2" do
    image = @builder.build( :width => 2, :height => 2, :name => "image1",
                           :data => [0,1,2,3,4,5,6,
                                     0,0,0,0,0,0,0])
    result = image
    # filter byte of 2
    result.filter_encoded_rows(2).should == [[2, 1, 2, 3, 4, 5, 6], [2, 255, 254, 253, 252, 251, 250]]
  end
end
