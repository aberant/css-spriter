require 'stringio'

module PNG
  class IDAT < Chunk
    attr_reader :uncompressed
    
    def initialize( uncompressed=[] )
      @uncompressed = uncompressed
    end

    def <<( data )
      @uncompressed += Zlib::Inflate.inflate( data ).unpack("C*")
    end
    
    def encode
      Zlib::Deflate.deflate( @uncompressed )
    end
    
    def chunk_name
      "IDAT"
    end
  end
end