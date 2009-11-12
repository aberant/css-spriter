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

describe "Dir sprite" do 
  before :all do 
    @dir = File.dirname(__FILE__) + "/sprite_dirs/words"
    @spriter = DirectorySpriter.new(@dir)
    @sprite_file = @dir + "/sprite.png"
    @css_file = @dir + "/fragment.css"
    @spriter.process
  end
  after :all do 
    File.delete @sprite_file rescue {}
    File.delete @css_file rescue {}
  end

  describe "Sprite generation" do 
    it "provides the correct dir name" do 
      @spriter.dir_name.should == 'words'
    end

    it "find all the pngs in a directory" do 
      expected = ['latitude.png', 'of.png', 'set.png', 'specified.png']
      images = @spriter.images
      images.map{|f| f.split('/').last}.should == expected
    end

    it "sprites all the images in a directory" do 
      File.exists?(@sprite_file).should be_true
    end
  end

  describe "CSS fragments" do 
    it "should generate correct css" do 
      css = @spriter.css
      css.include?(".words_latitude").should be_true
      css.include?(".words_of").should be_true
    end
    it "should write css fragments for a sprite" do 
      File.exists?(@css_file).should be_true
    end
  end
end


