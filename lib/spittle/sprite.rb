module PNG
  class Sprite
    attr_reader :images
    def initialize
      @images = []
      @locations = {}
    end
    
    def merge_right( image )
      @images << image
    end
    
    def merge_left( image )
      @images.unshift( image )
    end
    
    def locations
      x_sum = 0
      
      @images.reverse.each do |image|  
        x_sum = image.width + x_sum
        @locations[image.name.to_sym] = { :x => -(x_sum), :width => image.width }
      end
      
      @locations
    end
    

    def write( output_filename )
      # head is the last image, then we merge left
      head, *tail = @images.reverse
      
      result = tail.inject( head ){ |head, image| head.merge_left( image ) }
      
      result.write( output_filename )
    end
  end
end