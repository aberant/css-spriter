require 'benchmark'
require 'fileutils'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MtimeTracker do
  describe "on a new directory" do 
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

    it "tells me things have not changed after I update the tracking" do 
      @tracker.update
      @tracker.has_changes?.should be_false
    end
  end

  describe "on an existing directory" do 
    before do 
      @img_dir = File.dirname(__FILE__) + '/images'
      MtimeTracker.new(@img_dir).update
      @tracker = MtimeTracker.new(@img_dir)
    end

    after do
      File.delete(@img_dir + "/.mtimes") rescue {}
    end

    it "tells me nothing has changed" do 
      @tracker.has_changes?.should be_false
    end

    describe "when a file has changed" do 
      before do 
        FileUtils.touch(@img_dir + "/lightening.png")
        @tracker.reset
      end

      it "returns true from has_changes" do 
        @tracker.has_changes?.should be_true
        @tracker.changeset.first.should == "./spec/images/lightening.png"
      end
    end

    describe "file exclustions" do 
      before do 
        @img_dir = File.dirname(__FILE__) + '/images'
        @tracker = MtimeTracker.new(@img_dir, :exclude => [/lightening/, "tacos"])
      end

      after do 
        File.delete(@img_dir + "/.mtimes") rescue {}
      end

      it "does not report excluded files as changed" do 
        FileUtils.touch(@img_dir + "/lightening.png")
        @tracker.has_changes?.should be_false
      end
    end
  end
end
