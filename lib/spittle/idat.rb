module PNG
  class IDAT < Chunk
        
    def initialize( uncompressed="" )
      @compressed = ""
      @compressed += Zlib::Deflate.deflate( uncompressed.pack("C*") ) unless uncompressed == ""
    end

    def <<( data )
      @compressed << data
    end
    
    def encode
      @compressed
    end
    
    def uncompressed
      @uncompressed ||= Zlib::Inflate.inflate( @compressed ).unpack("C*")
    end
    
    def chunk_name
      "IDAT"
    end
  end
end