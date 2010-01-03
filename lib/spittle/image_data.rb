require 'enumerator'

module Spittle
  class ImageData
    RGB_WIDTH = 3
    RGBA_WIDTH = 4

    def initialize(options = {})
      @data = (options.delete :data) || []
      @properties = options
    end

    def name; @properties[:name] || "default"; end
    def scanline_width; @properties[:scanline_width]; end
    def width; scanline_width / pixel_width; end
    def pixel_width; @properties[:pixel_width]; end

    # need better checks, because currently compatible is
    # similar color type, or depth.. maybe it doesn't matter...
    def compatible?(image)
      self.pixel_width == image.pixel_width
    end

    def to_s
      "#{name} pixel width: #{pixel_width}"
    end

    def last_scanline(idx)
      last_row_index = idx - 1
      (last_row_index < 0 ? [] : @data[last_row_index])
    end

    def merge_left( other )
      merged = ImageData.new(@properties.merge(:scanline_width => self.scanline_width + other.scanline_width,
                                               :name => "#{self.name}_#{other.name}"))
      other.each_with_index do |row, idx|
        merged[idx] = row + self[idx]
      end
      merged
    end

    def fill_to_height( desired_height )
      return self if desired_height == height

      img = ImageData.new(@properties.merge(:data => @data.clone))
      empty_row = [0] * ( scanline_width )

      ( desired_height - height ).times do
        img << empty_row
      end
      img
    end

    def to_rgba( alpha_value=255 )
      # test that conversion updates pixel width, scanline width

      return self if pixel_width == RGBA_WIDTH

      # so ruby 1.9 has different ideas then 1.8 on how Enumerable should work
      # 1.9 returns Enumerable object if no block given
      # 1.8 complains if no block, unless using enum_x methods
      slice_method = (RUBY_VERSION.include?( "1.9" )) ? :each_slice : :enum_slice

      rgba_data = @data.map do |row|
        pixels = row.send( slice_method, RGB_WIDTH )
        pixels.inject([]){|result, pixel| result + pixel + [alpha_value] }
      end

      ImageData.new( :data => rgba_data,
                     :pixel_width => 4,
                     :scanline_width => (@properties[:scanline_width] / RGB_WIDTH) * RGBA_WIDTH,
                     :name => name)
    end

    def [](row)
      @data[row]
    end

    def []=(idx, row_data)
      @data[idx] = row_data
    end

    def scanline(row)
      self[row]
    end

    def empty?
      @data.empty?
    end

    def height
      size
    end

    def size
      @data.size
    end

    def last
      @data.last
    end

    def <<(row)
      @data << row
      self
    end

    def each(&block)
      @data.each &block
    end

    def each_with_index(&block)
      @data.each_with_index(&block)
    end

    def flatten!
      @data.flatten!
    end

    def pack(*args)
      @data.pack(*args)
    end

    def == (other)
      @data == other
    end
  end
end
