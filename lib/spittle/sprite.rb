module PNG
  class ImageFormatException < Exception; end
  class Sprite
    attr_reader :images

    def initialize
      @images = []
      @locations = {}
    end
    
    def append( image )
      @images.each do |i|
       unless i.compatible? image
         raise ImageFormatException.new("Incompatible images")
       end
      end
      @images << image
    end
    
    def locations
      @images.inject(0) do |x, image|  
        @locations[image.name.to_sym] = { :x => -(x), :width => image.width }
        image.width + x
      end
      @locations
    end

    def write( output_filename )
      return if @images.empty?

      # head is the last image, then we merge left
      head, *tail = @images.reverse
      result = tail.inject( head ){ |head, image| head.merge_left( image ) }
      result.write( output_filename )
    end
  end
end
