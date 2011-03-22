module CssSpriter
  class Image < ::ChunkyPNG::Image
    attr_accessor :name

    def self.from_file( filename )
      name = File.basename( filename, ".png" )

      image = super
      image.name = name
      image
    end
  end
end