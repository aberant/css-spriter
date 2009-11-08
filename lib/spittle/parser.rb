module PNG
  class Parser
    
    def go!( file )
      check_header( file )
      
      while(! file.eof?) do 
        parse_chunk(file)
      end
      
      [ @ihdr, @idat ]
    end
    
  private
    def check_header( file )
      header = file.read(8)
      
      raise "Invalid PNG file header" unless ( header == FileHeader.new.encode)
    end
    
    def parse_chunk(f)
      len = f.read(4).unpack("N")
      type = f.read(4)
      data = f.read(len[0])
      crc = f.read(4)
      
      raise "invalid CRC for chunk type #{type}" if crc_invalid?( type, data, crc )
      
      handle(type, data)
    end
    
    def handle(type, data)
      case(type)
      when "IHDR"
        @ihdr = PNG::IHDR.new_from_raw( data )
        @width, @height, @depth, @color_type = @ihdr.to_a
      when "IDAT"
        @idat ||= PNG::IDAT.new
        @idat << data 
      when "IEND"
        # NOOP
      else
        puts "Ignoring chunk type #{type}"
      end
    end
    
    def crc_invalid?( type, data, crc )
      [Zlib.crc32( type + data )] != crc.unpack("N")
    end
    
  end
end