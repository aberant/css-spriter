module CssSpriter
  class Image < ::ChunkyPNG::Image
    attr_accessor :name

    def self.from_file( filename )
      name = File.basename( filename, ".png" )

      image = super
      image.name = name
      image
    rescue => e
      raise LoadingError, "Error loading #{filename}: #{e.message}"
    end
    
    class LoadingError < StandardError; end
  end
end