module Spittle
  class Processor
    def initialize(opts)
      #puts "Processing Directory #{opts[:source]}"
      @options = opts
      @processors = dir_processors
      @css_builder = StylesheetBuilder.new(@options[:source])
      @css_builder.output_file(@options[:css_file] || @options[:source] + "/sprite.css")
    end

    def write
      @processors.each{|d| d.write}
      @css_builder.write
    end

    def directories
      Dir.glob(@options[:source] + "/**/").map{|d| d.gsub(/\/$/, "")}
    end

    def dir_processors
      directories.map{|d| DirectoryProcessor.new(d, @options)}
    end

    def cleanup
      @processors.each{|d| d.cleanup}
      @css_builder.cleanup
    end
  end
end
