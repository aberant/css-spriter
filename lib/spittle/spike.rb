module PNG
  class Spike
    class << self
      def open(file_name)
        png = PNG::Image.open( file_name )
      end
    end

  end
end