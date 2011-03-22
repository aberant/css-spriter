class ImageBuilder
  def initialize( general_options={} )
     default_options = {
       :width => 100,
       :height => 100,
       :name => "test"
     }
     @general_options =  default_options.merge general_options
   end

   def build( specific_options={} )
     args = @general_options.merge specific_options

     image = CssSpriter::Image.new( args[:width], args[:height], ChunkyPNG::Color::TRANSPARENT )
     image.name = args[:name]
     image
   end
end
