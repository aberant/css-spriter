module PNG
  class IHDR
    attr_accessor :width, :height, :depth, :color_type
    # attr_accessor :compression_method, :filter_method, :interlace_method
    
    def self.new_from_raw( data )
      raw = data.unpack("N2C5")
      
      new( *raw[0..3] )
    end
    
    def initialize( width, height, depth=8, color_type=2 )
      @width, @height, @depth, @color_type = width, height, depth, color_type
    end
    
    def encode
      to_a.pack("N2C5")
    end
    
    def to_a
      [@width, @height, @depth, @color_type, 0, 0, 0]
    end
  end
end