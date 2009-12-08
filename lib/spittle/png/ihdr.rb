module PNG
  class IHDR < Chunk
    SUPPORTED_COLOR_TYPES = [2,3,6]
    attr_accessor :width, :height, :depth, :color_type
    # attr_accessor :compression_method, :filter_method, :interlace_method
    
    def self.new_from_raw( data )
      raw = data.unpack("N2C5")
      
      new( *raw[0..3] )
    end
    
    def initialize( width, height, depth=8, color_type=2 )
      raise "for now, spittle only supports images with a bit depth of 8" unless depth == 8
      unless SUPPORTED_COLOR_TYPES.include? color_type
        raise "for now, spittle only supports color types #{SUPPORTED_COLOR_TYPES.JOIN(',')} color type was #{color_type}"
      end
      @width, @height, @depth, @color_type = width, height, depth, color_type
    end
    
    def encode
      to_a.pack("N2C5")
    end
    
    def to_a
      [@width, @height, @depth, @color_type, 0, 0, 0]
    end
    
    def chunk_name
      "IHDR"
    end
  end
end
