require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'PNG' do
  before do 
    @img_dir = File.dirname(__FILE__) + '/images'
    @expected_dir = File.dirname(__FILE__) + '/expected_output'
    @tmp_dir = File.dirname(__FILE__) + '/tmp'
  end

  it 'can read and write a PNG' do 
    img = PNG::Image.open("#{@img_dir}/lightening.png")
    img.write("#{@tmp_dir}/write_test.png")
    read("#{@expected_dir}/write_test.png").should == read("#{@tmp_dir}/write_test.png")
  end

  it 'can merge one PNG on the right of another' do 
    one = PNG::Image.open("#{@img_dir}/lightening.png")
    two = PNG::Image.open("#{@img_dir}/lightening.png")
    merged = one.merge_left two
    merged.write("#{@tmp_dir}/merge_right_test.png")
    read("#{@expected_dir}/merge_right_test.png").should == read("#{@tmp_dir}/merge_right_test.png")
  end

  def read(file_name)
    File.readlines(file_name)
  end
end
