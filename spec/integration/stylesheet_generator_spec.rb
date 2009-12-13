require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Stylesheet generator' do 
  before :all do 
    @dir = File.dirname(__FILE__) + "/../css_fragments"
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