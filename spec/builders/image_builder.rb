class ImageBuilder
  def initialize( general_options={} )
     default_options = {
       :width => 100,
       :height => 100,
       :data => [],
       :name => "test"
     }

     @general_options =  default_options.merge general_options
   end


   def build( specific_options={} )
     args = @general_options.merge specific_options
     
     ihdr = PNG::IHDR.new( args[:width], args[:height] )
     idat = PNG::IDAT.new( args[:data] )
     
     PNG::Image.new( ihdr, idat, args[:name] )
   end
end