module PNG
  class IEND < Chunk
    def encode; "" end
    
    def chunk_name
      "IEND"
    end
  end
end