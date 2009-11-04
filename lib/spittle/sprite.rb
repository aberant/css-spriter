=begin
thinking out loud about the next step for the sprite class

since the ultimite goal is to point this to a dir and make a sprite of all the pngs, we need to introduce the 
concept of a "name" to an image.  it could either be the filename, or an arbitrary name.  considering the ultimate
usage, i think the filename (minus path information and extension) would make the most sense.

when we write out the sprite, we can then construct a hash with the key as the image name, and the x,y cordinates 
of each image in the sprite.  it might make the most sense to then yaml-ize this and save it with the same file name as the sprite.

so i'm seeing the sprite-ification of these images being done before deployment. then in the web app, light weight yaml reading
objects are loaded to represent the sprites.  these objects are then used to construct the sass/css file.

=end

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