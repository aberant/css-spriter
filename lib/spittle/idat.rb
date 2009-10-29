module PNG
  class IDAT < Chunk
    attr_reader :uncompressed
    
    def self.concat_to_uncompressed( idats )
      idats.inject( [] ){ |array, idat| array + idat.uncompressed }
    end
    
    def initialize( uncompressed=[] )
      @uncompressed = uncompressed
    end

    def <<( compressed )
      @uncompressed += Zlib::Inflate.inflate( compressed ).unpack("C*")
    end
    
    def encode
      Zlib::Deflate.deflate( @uncompressed )
    end
    
    def chunk_name
      "IDAT"
    end
  end
end