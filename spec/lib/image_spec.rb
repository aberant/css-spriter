require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PNG::Image do
  before :each do
    @sprite = PNG::Sprite.new
    
    @builder = ImageBuilder.new
    
    # 0 is the filter type for the row, then an RGB triplet since builder defaults to color type 2
    @image1 = @builder.build( :width => 1, :height => 1, :name => "image1", :data => [0,1,2,3] )
    @image2 = @builder.build( :width => 1, :height => 1, :name => "image2", :data => [0,4,5,6] )
  end

  it "can merge left" do
    result = @image1.merge_left @image2
    
    result.rows.should == [[4,5,6,1,2,3]]
  end
  
  it "can insert empty rows to convert an image to a specific height" do
    result = @image1.fill_to_height(2)
    result.rows.should == [[1, 2, 3],
                           [0, 0, 0]]
  end
  
  it "can encode the rows with filter 0" do
    result = @image1.fill_to_height(2)
    result.filter_encoded_rows(0).should == [[0, 1, 2, 3], [0, 0, 0, 0]]
  end
  
  
  it "can encode the rows with filter 1" 
end