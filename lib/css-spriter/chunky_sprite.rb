require 'chunky_png'

class ChunkySprite
  attr_reader :images, :max_height

  def initialize
    @images = []
    @locations = {}
  end

  def append( image )
    @images << image
    @max_height = @images.map{ |i| i.height }.max
  end

  def append_file( filename )
    append( ChunkyPNG::Image.from_file( filename ))
  end

  def locations
    @images.inject(0) do |x, image|
      @locations[image.name.to_sym] = { :x => -(x),
        :width => image.width,
        :height => image.height}
      image.width + x
    end
    @locations
  end

  def write( output_filename )
    return if @images.empty?

    sprite_height = @images.map{ |i| i.height }.max
    sprite_width = @images.inject(0){|sum, image| sum + image.width }

    sprite = ChunkyPNG::Image.new(sprite_width, sprite_height)

    current_x = 0

    images.each do |image|
      sprite.replace(image, current_x, 0)
      current_x += image.width
    end

    sprite.save( output_filename, :best_compression )
  end
end