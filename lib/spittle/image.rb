module PNG

  class Image

    def self.open( file_name )
      name = File.basename( file_name, ".png" )

      File.open(file_name, "r") do |f|
        ihdr, idat = Parser.go!( f )
        Image.new( ihdr, idat, name )
      end

    end

    def initialize( ihdr, idat, name, options = {} )
      @ihdr = ihdr
      @idat = idat
      @name = name
      @rows = options[:rows]
    end

    attr_reader :name
    def width; @ihdr.width end
    def height; @ihdr.height end
    def depth; @ihdr.depth end
    def color_type; @ihdr.color_type end
    def uncompressed; @idat.uncompressed end

    # need better checks, because currently compatible is
    # similar color type, or depth.. maybe it doesn't matter...
    def compatible?(image)
      self.color_type == image.color_type &&
      self.depth == image.depth
    end

    def write(file_name, options={})
      filter_type = options[:filter_type] || 4
      File.open(file_name, 'w') do |f|
        f.write(generate_png( filter_type ))
      end
    end

    def fill_to_height( desired_height )
      raise "invalid height" if desired_height < height
      return self if desired_height == height

      data = rows.clone

      empty_row = [0] * ( width * pixel_width )

      ( desired_height -  height ).times do
        data << empty_row
      end

      ihdr = IHDR.new( width, desired_height, depth, color_type )

      Image.new( ihdr, nil, name, :rows => data )
    end

    def to_s
      inspect
    end

    def merge_left( other )
      #puts "merging #{self.name} into #{other.name}"
      l = other.rows
      r = self.rows

      merged = Array.new(l.size)
      l.each_with_index do |row, idx|
        merged[idx] = row + r[idx]
      end
      data = merged

      ihdr = IHDR.new( width + other.width, height, depth, color_type)
      img_name  = "#{name}_#{other.name}"

      Image.new( ihdr, nil, img_name, :rows => data )
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
      @rows ||= to_rows
    end

    def to_rows
      uncompressed = @idat.uncompressed

      out = Array.new(height)
      offset = 0

      height.times do |scanline|
        end_row = scanline_width + offset
        row = uncompressed.slice(offset, scanline_width)
        out[scanline] = decode(scanline, row, out, pixel_width)
        offset = end_row
      end
      out
    end

    def inspect
      "#{@name} (#{height} x #{width}) [color type: #{color_type}, depth: #{depth}]"
    end
  private

    def last_scanline(current, data)
      last_row_index = current - 1
      (last_row_index < 0 ? [] : data[last_row_index])
    end

    def decode(current, row, data, pixel_width)
      filter_type = row.shift

      decode_row(row, last_scanline(current, data), filter_type, pixel_width)
    end

    def decode_row(row, last_scanline, filter_type, pixel_width)
      o = Array.new(row.size)
      row.each_with_index do |byte, i|
        o[i] = Filters.decode(filter_type, byte, i, o, last_scanline, pixel_width)
      end
      o
    end

    def generate_png( filter_type )
      file_header = PNG::FileHeader.new.encode
      raw_data = rows.clone
      raw_data.each { |row| row.unshift(0) }
      raw_data.flatten!

      ihdr = PNG::IHDR.new( width, height, depth, color_type ).to_chunk
      idat = PNG::IDAT.new( raw_data ).to_chunk
      iend = PNG::IEND.new.to_chunk

      file_header + ihdr + idat + iend
    end
  end
end
