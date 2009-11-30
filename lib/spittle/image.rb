module Spittle
  class Image
    def initialize(properties, data)
      @properties = properties
      @data = Data.new(data)
    end
  end
end

module PNG

  class Image
    def self.default_filter_type
      4 # paeth
    end

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
      filter_type = options[:filter_type] || Image.default_filter_type
      File.open(file_name, 'w') do |f|
        f.write(generate_png( filter_type ))
      end
    end

    def fill_to_height( desired_height)
      raise "invalid height" if desired_height < height
      return self if desired_height == height
      data = rows.fill_to_height(desired_height)
      ihdr = IHDR.new( width, desired_height, depth, color_type )

      Image.new( ihdr, nil, name, :rows => data )
    end

    def to_s
      inspect
    end

    def merge_left(other)
      merged = rows.merge_left(other.rows)

      ihdr = IHDR.new( width + other.width, height, depth, color_type)
      img_name  = "#{name}_#{other.name}"

      Image.new( ihdr, nil, img_name, :rows => merged )
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

    def filter_encoded_rows( filter_type )
      out = Array.new(height)
      rows.each_with_index do |row, scanline|
        last_row = rows.last_scanline(scanline)
        out[scanline] = encode_row( row, last_row, filter_type, pixel_width)
      end
      out
    end

    def to_rows
      uncompressed = @idat.uncompressed

      #scanline_width - 1 because we're stripping the filter bit
      n_out = Spittle::ImageData.new(:scanline_width => scanline_width - 1,
                                     :pixel_width => pixel_width,
                                     :data => Array.new(height))
      offset = 0
      height.times do |scanline|
        end_row = scanline_width + offset
        row = uncompressed.slice(offset, scanline_width)
        n_out[scanline] = decode(scanline, row, n_out, pixel_width)
        offset = end_row
      end
      n_out
    end

    def inspect
      "#{@name} (#{height} x #{width}) [color type: #{color_type}, depth: #{depth}]"
    end
  private

    def decode(current, row, data, pixel_width)
      filter_type = row.shift
      decode_row(row, data.last_scanline(current), filter_type, pixel_width)
    end

    def decode_row(row, last_scanline, filter_type, pixel_width)
      o = Array.new(row.size)
      row.each_with_index do |byte, i|
        o[i] = Filters.decode(filter_type, byte, i, o, last_scanline, pixel_width)
      end
      o
    end

    def encode_row( row, last_scanline, filter_type, pixel_width )
      o = Array.new(row.size)
      row.each_with_index do |byte, scanline|
        o[scanline] = Filters.encode( filter_type, byte, scanline, row, last_scanline, pixel_width)
      end
      o.unshift( filter_type )
    end

    def generate_png( filter_type )
      file_header = PNG::FileHeader.new.encode
      raw_data = filter_encoded_rows( filter_type )
      raw_data.flatten!

      ihdr = PNG::IHDR.new( width, height, depth, color_type ).to_chunk
      idat = PNG::IDAT.new( raw_data ).to_chunk
      iend = PNG::IEND.new.to_chunk

      file_header + ihdr + idat + iend
    end
  end
end
