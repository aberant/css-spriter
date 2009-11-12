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
    before :all do 
      @css = @spriter.css
    end

    it "should compose class names" do 
      @css.should include ".words_latitude"
      @css.should include ".words_of"
    end

    it "has the correct image path" do 
      @css.should include "/sprite_dirs/words/sprite.png"
    end

    it "should write css fragments for a sprite" do 
      File.exists?(@css_file).should be_true
    end
  end
end

describe 'Stylesheet generator' do 
  before :all do 
    @dir = File.dirname(__FILE__) + "/css_fragments"
    @out = @dir + "/complete.css"
    @builder = StylesheetBuilder.new(@dir)
    @builder.output_file(@out)
    @css = @builder.css
  end

  after :all do 
    File.delete @out rescue {}
  end

  it "takes the css fragments and concatonates them into a single stylesheet" do 
    @css.should include ".some_style"
  end

  it "can handle nested folder structures" do 
    @css.should include ".deep"
  end

  it "writes the css file to the specified location" do 
    @builder.write
    File.exists?(@out).should be_true
  end
end
