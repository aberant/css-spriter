module PNG
  class IHDR
    attr_accessor :width, :height, :depth, :color_type
    
    def initialize( data )
      raw = data.unpack("N2C5")
      @width, @height, @depth, @color_type, _, _, _ = raw
    end
  end
end