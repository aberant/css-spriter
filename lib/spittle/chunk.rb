module PNG
  class Chunk
    def chunk_name
      raise "looks like you havn't subclassed and defined a chunk_name"
    end
    
    def to_chunk
      to_check = chunk_name + encode
      [encode.length].pack("N") + to_check + [Zlib.crc32(to_check)].pack("N")
    end
  end
end