require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Complete spriting process" do 
  before :all do 
    @dir = File.dirname(__FILE__) + "/../sprite_dirs"
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
    file.should include("/images/sprite_dirs/words")
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