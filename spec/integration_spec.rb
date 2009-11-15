require 'benchmark'
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

  it 'can merge one PNG on the left of another' do 
    one = PNG::Image.open("#{@img_dir}/lightening.png")
    two = PNG::Image.open("#{@img_dir}/lightening.png")
    merged = one.merge_left two
    merged.write("#{@tmp_dir}/merge_right_test.png")
    read("#{@expected_dir}/merge_right_test.png").should == read("#{@tmp_dir}/merge_right_test.png")
  end

end

describe "Dir sprite" do 
  before :all do 
    @dir = File.dirname(__FILE__) + "/sprite_dirs/words"
    @spriter = DirectoryProcessor.new(@dir)
    @sprite_file = @dir + "/sprite.png"
    @css_file = @dir + "/fragment.css"
    @spriter.write
  end

  after :all do 
    @spriter.cleanup
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
      @template = @dir + "/template.css"
      @css = @spriter.css
    end

    after do 
      File.delete(@template) rescue {}
    end

    it "should compose class names" do 
      @css.should include( ".words_latitude")
      @css.should include( ".words_of" )
    end

    it "has the correct image path" do 
      @css.should include( "/sprite_dirs/words/sprite.png" )
    end

    it "should write css fragments for a sprite" do 
      File.exists?(@css_file).should be_true
    end

    it "can be overidden by including a template.css in the sprite directory" do 
      File.open(@template, 'w'){|f| f.write("override")}
      @spriter.write
      @spriter.css.should include("override")
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
    @builder.cleanup
  end

  it "takes the css fragments and concatonates them into a single stylesheet" do 
    @css.should include( ".some_style" )
  end

  it "can handle nested folder structures" do 
    @css.should include( ".deep" )
  end

  it "writes the css file to the specified location" do 
    @builder.write
    File.exists?(@out).should be_true
  end
end

describe "Complete spriting process" do 
  before :all do 
    @dir = File.dirname(__FILE__) + "/sprite_dirs"
    @css_file = @dir + "/sprite.css"
    @spittle = Spittle::Processor.new(:path_prefix => "/images", :source => @dir, :css_file => @css_file)
    @spittle.write
  end

  after :all do 
    @spittle.cleanup
    #making sure it cleans things up - shitty place for these
    File.exists?(@css_file).should be_false
    File.exists?(@dir + "/words/sprite.png").should be_false
  end

  it "prepends a path prefix to all sprites in the css file" do 
    file = read(@css_file)
    file.should include("/images/spec/sprite_dirs/words")
  end

  it "can find all the sprite directories" do 
    dirs = @spittle.directories.map{|d| d.split('/').last}
    dirs.should include( "words" )
  end

  it "generates the css file at the appropriate location" do 
    File.exists?(@css_file).should be_true
  end

  it "creates sprites/css for all subfolders" do 
    File.exists?(@dir + "/words/sprite.png").should be_true
    File.exists?(@dir + "/words/fragment.css").should be_true
  end
end

def read(file_name)
  File.read(file_name)
end

