module PNG
  class Image
    
    def self.open( file_name )
      @parser = Parser.new
      
      name = File.basename( file_name, ".png" )
      
      File.open(file_name, "r") do |f|
        ihdr, idat = @parser.go!( f )
        
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
      r = nil
      data.flatten!
      
      ihdr = IHDR.new( width + other.width, height, depth, color_type)
      idat = IDAT.new( data )
      img_name  = "#{name}_#{other.name}"
      
      Image.new( ihdr, idat, img_name )
    end
  
    def rows
     out = []
     offset = 0
     
     # check for RGB or RGBA
     record_width = ( color_type == 2 ? 3 : 4)
     
     pixel_width = (width * record_width) + 1 
     
     height.times do |c_row| 
       end_row = pixel_width + offset
       row = @idat.uncompressed.slice(offset, pixel_width)
       out << decode(c_row, row, out)
       offset = end_row
     end
     out
    end
    
    def inspect
      "color type: #{color_type}, depth: #{depth}, width: #{width}, height: #{height}"
    end
  private
    
    def decode(c_row, row, data)
      last_row = (c_row - 1 < 0 ? [] : data[c_row - 1])
      type = row.shift
      filter = Filters[type]
      process_row(row, last_row, filter)
    end
    
    def process_row(row, last_row, filter)
      o = []
      row.each_with_index do |e, i|
        o[i] = filter.call(e, i, o, last_row)
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
  