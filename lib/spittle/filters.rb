module PNG
  class Filters
    class << self
      def fetch_pixel(idx, row)
        idx < 0 ? 0 : row[idx] || 0
      end

      #filter methods are inlined here for performance
      def call( filter_type, value, index, row, last_row, record_width )
        case filter_type
        when 0
          #no filter
          value
        when 1
          #up
          (value + fetch_pixel(index - record_width, row)) % 256
        when 2
          #left
          (value + fetch_pixel(index, last_row)) % 256
        when 3
          #avg
          (value + ( (fetch_pixel(index - record_width, row) + fetch_pixel(index, last_row)) / 2 ).floor) % 256
        when 4
          #paeth
          a = fetch_pixel(index - record_width, row)
          b = fetch_pixel(index, last_row)
          c = fetch_pixel(index - record_width, last_row)
          p = a + b - c
          pa = (p - a).abs
          pb = (p - b).abs
          pc = (p - c).abs

          pr = c
          if ( pa <= pb and pa <= pc) 
            pr = a
          elsif (pb <= pc)
            pr = b
          end
          (value + pr) % 256
        else
          raise "Invalid filter type (#{filter_type})"
        end
      end
    end
  end
end
