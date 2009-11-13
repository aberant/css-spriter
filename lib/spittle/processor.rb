module Spittle
  class Processor
    def initialize(opts)
      @options = opts
      @d_processors = dir_processors
      @css_builder = StylesheetBuilder.new(@options[:source])
      @css_builder.output_file(@options[:css_file])
    end

    def write
      @d_processors.each{|d| d.write}
      @css_builder.write
    end

    def directories
      #better way to find all directories than this?
      Dir.glob(@options[:source] + "/**").select{|e| File.directory? e }
    end

    def dir_processors
      directories.map{|d| DirectoryProcessor.new(d)}
    end

    def cleanup
      @d_processors.each{|d| d.cleanup}
      @css_builder.cleanup
    end
  end
end
