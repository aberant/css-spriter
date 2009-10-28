module PNG
  class Spike
    class << self
      def open(file_name)
        png = Spike.new
        png.open(file_name)
        png
      end
    end

    attr_reader :width, :height, :depth, :color_type, :data

    def initialize(data = [], width = 0, height = 0, depth = 8, color_type = 2)
      @data, @width, @height = data, width, height
      @depth, @color_type = @depth, @color_type
    end

    def open(file_name)
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
        @idat = PNG::IDAT.new( data ) 
      when "IEND"
        # NOOP
      else
        puts "Ignoring chunk type #{type}"
      end
    end
  
    def decompress
      @data = @idat.decompress
    end

    def rows
     out = []
     offset = 0
     pixel_width = (width * 3) + 1 #1 filter byte * 3 for 3 rgb bytes  TODO: incompatible with other color types
     height.times do |c_row| 
       end_row = pixel_width + offset
       row = @data.slice(offset, pixel_width)
       out << decode(c_row, row, out)
       offset = end_row
     end
     out
    end

    def self.fetch_pixel(idx, row)
      return 0 if row.empty?
      return 0 if idx < 0
      return row[idx] || 0
    end

    FILTERS = {0 => lambda {|value, index, row, last_row| value},
               1 => lambda {|value, index, row, last_row|
                (value + fetch_pixel(index - 3, row)) % 256
              }, 
               2 => lambda {|value, index, row, last_row|
                (value + fetch_pixel(index, last_row)) % 256
              },
               3 => lambda {|value, index, row, last_row| 
                (value + ( (fetch_pixel(index - 3, row) + fetch_pixel(index, last_row)) / 2 ).floor) %256
              },
               4 => lambda {|value, index, row, last_row| 
                a = fetch_pixel(index - 3, row)
                b = fetch_pixel(index, last_row)
                c = fetch_pixel(index - 3, last_row)
                p = a + b - c
                pa = (p - a).abs
                pb = (p - b).abs
                pc = (p - c).abs
              
                pr = c
                if ( pa <= pb and pa <= pc) 
                  pr = a
                elsif (pb <= pc)
                  pr = b
                end

                (value + pr) % 256
              }}

  
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

    # Merge
    def merge_right(other)
      l = self.rows
      r = other.rows

      data = l.zip r
      data.each { |row| row.unshift(0) } #prepend the filter byte o = no filter
      r = nil
      data.flatten!
      Spike.new(data, width + other.width, height, depth, color_type)
    end

    # Write methods
    #

    def write(file_name)
      File.open(file_name, 'w') do |f|
        f.write(generate_png)
      end
    end
  
    def generate_png
      header = PNG::FileHeader.new.encode
      
      raw_data = @data.pack("C*")

      ihdr = PNG::IHDR.new( width, height ).to_chunk
      idat = chunk("IDAT", Zlib::Deflate.deflate(raw_data))
      iend = chunk("IEND", "")
      header + ihdr + idat + iend
    end

    def chunk(type, data)
      to_check = type + data
      [data.length].pack("N") + to_check + [Zlib.crc32(to_check)].pack("N")
    end
  
  end
end