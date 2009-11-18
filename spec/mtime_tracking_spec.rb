require 'benchmark'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MtimeTracker do
  describe "on a clean directory" do 
    before do 
      @img_dir = File.dirname(__FILE__) + '/images'
      @tracker = MtimeTracker.new(@img_dir)
    end

    after do
      File.delete(@img_dir + "/.mtimes") rescue {}
    end

    it "tells me there are changes" do 
      @tracker.has_changes?.should be_true
    end

    it "tells me things have not changed after :I update the tracking" do 
      @tracker.update
      @tracker.has_changes?.should be_false
    end
  end
end

