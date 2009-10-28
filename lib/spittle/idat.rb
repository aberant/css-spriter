module PNG
  class IDAT
    def initialize( compressed )
      @compressed = compressed
    end
    
    def decompress
      Zlib::Inflate.inflate( @compressed ).unpack("C*")
    end
  end
end