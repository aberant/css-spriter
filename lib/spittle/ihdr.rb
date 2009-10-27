module PNG
  class IHDR
    attr_accessor :width, :height, :depth, :color_type
    # attr_accessor :compression_method, :filter_method, :interlace_method
    
    def initialize( data )
      raw = data.unpack("N2C5")
      @width, @height, @depth, @color_type, _, _, _ = raw
    end
  end
end