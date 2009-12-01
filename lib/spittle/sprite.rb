module PNG
  class ImageFormatException < Exception; end
  class Sprite
    attr_reader :images, :max_height

    def initialize
      @images = []
      @locations = {}
    end

    def append( image )
      @images.each do |i|
       unless i.compatible? image
         raise ImageFormatException.new("Image #{i} not compatible with #{image}")
       end
      end

      @images << image
      @max_height = @images.map{ |i| i.height }.max
    end

    def locations
      @images.inject(0) do |x, image|
        @locations[image.name.to_sym] = { :x => -(x),
          :width => image.scanline_width,
          :height => image.height}
        image.scanline_width + x
      end
      @locations
    end

    def write( output_filename )
      return if @images.empty?
      right_sized = @images.map{|i| i.fill_to_height(@max_height)}
      # head is the last image, then we merge left
      head, *tail = right_sized.reverse
      result = tail.inject( head ){ |head, image| head.merge_left( image ) }
      PNG::Image.write( output_filename, result )
    end
  end
end
