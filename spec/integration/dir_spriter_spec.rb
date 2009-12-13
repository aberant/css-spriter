require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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
      File.delete(@template) rescue nil
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
