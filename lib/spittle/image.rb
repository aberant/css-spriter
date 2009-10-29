module PNG
  class Image
    
    def self.fetch_pixel(idx, row)
      return 0 if row.empty?
      return 0 if idx < 0
      return row[idx] || 0
    end
    
    
    def initialize( ihdr, idats )
      @ihdr = ihdr
      @idats = idats
      
      @uncompressed = IDAT.concat_to_uncompressed( @idats )
    end
    
    def width; @ihdr.width end
    def height; @ihdr.height end
    def depth; @ihdr.depth end
    def color_type; @ihdr.color_type end
    
    
    def rows
     out = []
     offset = 0
     
     pixel_width = (width * 3) + 1 #1 filter byte * 3 for 3 rgb bytes  TODO: incompatible with other color types
     
     
     height.times do |c_row| 
       end_row = pixel_width + offset
       row = @uncompressed.slice(offset, pixel_width)
       out << decode(c_row, row, out)
       offset = end_row
     end
     out
    end
    
    def decode(c_row, row, data)
      last_row = (c_row - 1 < 0 ? [] : data[c_row - 1])
      type = row.shift
      filter = FILTERS[type]
      process_row(row, last_row, filter)
    end
    
    def process_row(row, last_row, filter)
      o = []
      row.each_with_index do |e, i|
        o[i] = filter.call(e, i, o, last_row)
      end
      o
    end
    
    def merge_right(other)
      l = self.rows
      r = other.rows

      data = l.zip r
      data.each { |row| row.unshift(0) } #prepend the filter byte o = no filter
      r = nil
      data.flatten!
      
      ihdr = IHDR.new( width + other.width, height, depth, color_type)
      idat = IDAT.new( data )
      
      Image.new( ihdr, [idat] )
    end
    
    
    def write(file_name)
      File.open(file_name, 'w') do |f|
        f.write(generate_png)
      end
    end
  
    def generate_png
      file_header = PNG::FileHeader.new.encode
      
      raw_data = @uncompressed.pack("C*")

      ihdr = PNG::IHDR.new( width, height ).to_chunk
      idat = PNG::IDAT.new( raw_data ).to_chunk
      iend = PNG::IEND.new.to_chunk
      
      file_header + ihdr + idat + iend
    end
  end
end
  