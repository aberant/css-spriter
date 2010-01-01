class DeInterlacer
  def initialize(height, width, pixel_width, raw, decoder)
    @height, @width, @decoder = height, width, decoder
    @pixel_width = pixel_width
    @raw = raw.dup
    @out = Spittle::ImageData.new :scanline_width => width, :pixel_width => pixel_width
  end

  def process
    pass1
    pass2
    @out
  end

  def pass1_height
    @height / 8
  end

  def pass1_width
  end

  def pass1
    sub_width = ((@width / 8) * @pixel_width) + 1
    sub_height = pass1_height
    scanline_width = @width / 8

    sub_image = Spittle::ImageData.new(:scanline_width => scanline_width,
                                   :pixel_width => @pixel_width,
                                   :data => [])
    sub_height.times do |line_idx|
      row = @raw.slice!(0, sub_width)
      l = @decoder.decode(line_idx, row, sub_image, @pixel_width)
      sub_image << l
    end
    sub_image

    #FUck!
    idxes = [0, (1..scanline_width - 1).to_a.map{ |i| (i * 8)}.map{|i| i - 1}].flatten
    rows = [0, (1..sub_height - 1).to_a.map{ |i| i * 8 }.map{|i| i - 1}].flatten
    
    input = sub_image.to_a
    rows.each do |row|
      idxes.each do |idx|
        pixel = input.take(@pixel_width)
        @out.set_pixel(row, idx, pixel)
      end
    end
  end

  def pass2
    sub_width = ((@width / 8) * @pixel_width) + 1
    sub_height = pass1_height
    scanline_width = @width / 8

    sub_image = Spittle::ImageData.new(:scanline_width => scanline_width,
                                   :pixel_width => @pixel_width,
                                   :data => [])
    offset = 0
    sub_height.times do |line_idx|
      row = @raw.slice!(0, sub_width)
      sub_image << @decoder.decode(line_idx, row, sub_image, @pixel_width)
    end
    sub_image

    #FUck!
    idxes = (0..scanline_width - 1).to_a.map{ |i| (i * 8) + 4}.map{|i| i - 1}
    rows = [0, (1..sub_height - 1).to_a.map{ |i| i * 8 }.map{|i| i - 1}].flatten
    
    input = sub_image.to_a
    rows.each do |row|
      idxes.each do |idx|
        pixel = input.take(@pixel_width)
        @out.set_pixel(row, idx, pixel)
      end
    end
  end
end
