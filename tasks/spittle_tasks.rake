#TODO - make this a rake task instead of a function
module Spittle
  def self.setup
     require 'fileutils'
     require File.dirname(__FILE__)  + "/../lib/spittle.rb"

     FileUtils.cd(RAILS_ROOT + "/public/images")
     opts = {:source =>  "sprites",
             :path_prefix =>  "/images",
             :css_file => RAILS_ROOT + '/public/stylesheets/sprites.css'}
  end
end

namespace :sprite do 
  desc "Generates sprite images and stylesheets"
  task :generate do 
    opts = Spittle.setup 
    Spittle::Processor.new(opts).write
  end
  desc "Removes generated sprite images and stylesheets"
  task :cleanup do 
    opts = Spittle.setup 
    Spittle::Processor.new(opts).cleanup
  end
end
