module PNG
  class IDAT < Chunk
    attr_reader :uncompressed
    
    def self.concat_to_uncompressed( idats )
      idats.inject( [] ){ |array, idat| array + idat.uncompressed }
    end
    
    def self.new_from_compressed( compressed )
      new( Zlib::Inflate.inflate( compressed ).unpack("C*") )
    end
    
    def initialize( uncompressed )
      @uncompressed = uncompressed
    end

    def encode
      Zlib::Deflate.deflate( @uncompressed )
    end
    
    def chunk_name
      "IDAT"
    end
  end
end