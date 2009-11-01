module PNG
  class Sprite
    attr_reader :images
    
    def initialize
      @images = []
    end
    
    def merge_right( image )
      @images << image
    end
    
    def merge_left( image )
      @images.unshift( image )
    end

    def write( output_filename )
      head, *tail = @images
      
      result = tail.inject( head ){|head, image|  head.merge_right( image )}
      
      result.write( output_filename )
    end
  end
end