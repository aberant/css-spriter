module Spittle
  class Row < Array
  end

  class ImageData
    def initialize(options = {})
      @data = (options.delete :data) || []
      @properties = options
    end

    def name; @properties[:name] || "default"; end
    def scanline_width; @properties[:scanline_width]; end
    def width; scanline_width; end
    def pixel_width; @properties[:pixel_width]; end

    # need better checks, because currently compatible is
    # similar color type, or depth.. maybe it doesn't matter...
    def compatible?(image)
      self.pixel_width == image.pixel_width
    end

    def last_scanline(idx)
      last_row_index = idx - 1
      (last_row_index < 0 ? [] : @data[last_row_index])
    end

    def merge_left( other )
      merged = ImageData.new(@properties.merge(:name => "#{self.name}_#{other.name}"))
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
