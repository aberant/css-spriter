module PNG
  class Image
    
    def self.open( file_name )
      name = File.basename( file_name, ".png" )
      
      File.open(file_name, "r") do |f|
        ihdr, idat = Parser.go!( f )
        Image.new( ihdr, idat, name )
      end
      
    end
    
    def initialize( ihdr, idat, name )
      @ihdr = ihdr
      @idat = idat
      @name = name
    end
    
    attr_reader :name
    def width; @ihdr.width end
    def height; @ihdr.height end
    def depth; @ihdr.depth end
    def color_type; @ihdr.color_type end

    def compatible?(image)
      self.height == image.height
    end
    
    def write(file_name)
      File.open(file_name, 'w') do |f|
        f.write(generate_png)
      end
    end
    
    def merge_left( other )
      l = other.rows
      r = self.rows
      
      data = l.zip r
      
      #prepend the filter byte 0 = no filter
      data.each { |row| row.unshift(0) } 
      data.flatten!
      
      ihdr = IHDR.new( width + other.width, height, depth, color_type)
      idat = IDAT.new( data )
      img_name  = "#{name}_#{other.name}"
      
      Image.new( ihdr, idat, img_name )
    end
    
    #color types
    RGB = 2
    RGBA = 3

    # check for RGB or RGBA
    def pixel_width
      ( color_type == RGB ? 3 : 4)
    end

    def scanline_width
      # + 1 adds filter byte
      (width * pixel_width) + 1
    end
  
    def rows
     out = []
     offset = 0
     
     height.times do |scanline|
       end_row = scanline_width + offset
       row = @idat.uncompressed.slice(offset, scanline_width)
       out << decode(scanline, row, out, pixel_width)
       offset = end_row
     end
     out
    end
    
    def inspect
      "color type: #{color_type}, depth: #{depth}, width: #{width}, height: #{height}"
    end
  private

    def last_scanline(current, data)
      (current - 1 < 0 ? [] : data[current - 1])
    end
      
    def decode(current, row, data, pixel_width)
      filter_type = row.shift
      
      process_row(row, last_scanline(current, data), filter_type, pixel_width)
    end
    
    def process_row(row, last_scanline, filter_type, pixel_width)
      o = []
      row.each_with_index do |e, i|
        o[i] = Filters.call(filter_type, e, i, o, last_scanline, pixel_width)
      end
      o
    end
    
    def generate_png
      file_header = PNG::FileHeader.new.encode
      raw_data = @idat.uncompressed
      
      ihdr = PNG::IHDR.new( width, height, depth, color_type ).to_chunk
      idat = PNG::IDAT.new( raw_data ).to_chunk
      iend = PNG::IEND.new.to_chunk
      
      file_header + ihdr + idat + iend
    end
  end
end
