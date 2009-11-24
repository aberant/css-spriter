class ImageBuilder
  def initialize( general_options={} )
     default_options = {
       :width => 100,
       :height => 100,
       :name => "test"
     }
     @general_options =  default_options.merge general_options
   end

   def data(width, height)
     Array.new((width * height * 3) + height).fill(0)
   end

   def build( specific_options={} )
     args = @general_options.merge specific_options
     
     ihdr = PNG::IHDR.new( args[:width], args[:height] )
     idat = PNG::IDAT.new( args[:data] || data(args[:width], args[:height]) )

     PNG::Image.new( ihdr, idat, args[:name] )
   end
end
