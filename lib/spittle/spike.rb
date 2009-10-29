module PNG
  class Spike
    class << self
      def open(file_name)
        png = Spike.new
        png.open(file_name)
      end
    end

    def open(file_name)
      @idats = []
      
      File.open(file_name, "r") do |f|
        header = f.read(8)
        
        while(! f.eof?) do 
          parse_chunk(f)
        end
      end
      decompress
    end
  
    # opening
    def parse_chunk(f)
      len = f.read(4).unpack("N")
      type = f.read(4)
      data = f.read(len[0])
      crc = f.read(4)
      handle(type, data)
    end
  
    #opening
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
  
    def decompress
      @image = PNG::Image.new( @ihdr, @idat )
    end

  end
end