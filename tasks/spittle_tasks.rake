 desc "Generates sprites"
 task :sprite do
   require File.dirname(__FILE__)  + "/../lib/spittle.rb"

   opts = {:source =>  RAILS_ROOT + "/public/images/sprites", 
           :path_prefix =>  "/images"}

   Spittle::Processor.new(opts).write
 end
