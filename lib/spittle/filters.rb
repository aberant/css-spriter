module PNG
  class Filters
    class << self
      #TODO: feature envy, this behavior belongs to a row. 
      def fetch_pixel(idx, row)
        return 0 if idx < 0
        return row[idx] || 0
      end

      def call( filter_type, value, index, row, last_row, record_width )
        case filter_type
        when 0
          no_filter( value, index, row, last_row, record_width )
        when 1
          left( value, index, row, last_row, record_width )
        when 2
          up( value, index, row, last_row, record_width )
        when 3
          avg( value, index, row, last_row, record_width )
        when 4
          paeth( value, index, row, last_row, record_width )
        else
          raise "Invalid filter type (#{filter_type})"
        end
      end
      
      def no_filter( value, index, row, last_row, record_width )
        value
      end
      
      def left( value, index, row, last_row, record_width )
        (value + fetch_pixel(index - record_width, row)) % 256
      end
      
      def up( value, index, row, last_row, record_width )
        (value + fetch_pixel(index, last_row)) % 256
      end
    
      def avg( value, index, row, last_row, record_width )
        (value + ( (fetch_pixel(index - record_width, row) + fetch_pixel(index, last_row)) / 2 ).floor) % 256
      end
    
      def paeth( value, index, row, last_row, record_width )
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
      end

    end
  end
end
