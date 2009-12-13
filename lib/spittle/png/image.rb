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

    #TODO - rename this 'image_data'
    def self.image_data( file_name )
      png = open(file_name)
      png.to_image
    end

    def self.write( file_name, data, options = {} )
      ihdr = PNG::IHDR.new(data.width, data.height, 8, color_type_of(data.pixel_width))
      Image.new(ihdr, nil, file_name, :rows => data).write( file_name, options)
    end

    #TODO - Nieve We should only store RBGA
    def self.color_type_of(pixel_width)
      case pixel_width
      when 3
        RGB
      when 4
        RGBA
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

    def write(file_name, options={})
      filter_type = options[:filter_type] || Image.default_filter_type
      File.open(file_name, 'w') do |f|
        f.write(generate_png( filter_type ))
      end
    end

    def to_s
      inspect
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
      @rows ||= to_image
    end

    def filter_encoded_rows(filter_type)
      out = Array.new(height)
      rows.each_with_index do |row, scanline|
        last_row = rows.last_scanline(scanline)
        out[scanline] = encode_row( row, last_row, filter_type, pixel_width)
      end
      out
    end

    def to_image
      uncompressed = @idat.uncompressed

      #scanline_width - 1 because we're stripping the filter bit
      n_out = Spittle::ImageData.new(:scanline_width => scanline_width - 1,
                                     :pixel_width => pixel_width,
                                     :name => self.name,
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
