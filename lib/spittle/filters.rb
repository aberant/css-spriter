module PNG
  class Filters
    class << self
      def fetch_pixel(idx, row)
        idx < 0 ? 0 : row[idx] || 0
      end

      #filter methods are inlined here for performance
      def decode( filter_type, value, index, row, last_row, record_width )
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
          left = fetch_pixel(index - record_width, row)
          above = fetch_pixel(index, last_row)
          upper_left = fetch_pixel(index - record_width, last_row)

          pr = paeth_predictor( left, above, upper_left )

          (value + pr) % 256
        else
          raise "Invalid filter type (#{filter_type})"
        end
      end
      def encode( filter_type, value, index, row, last_row, record_width )
        case filter_type
        when 0
          value
        when 4
          #paeth
          left = fetch_pixel(index - record_width, row)
          above = fetch_pixel(index, last_row)
          upper_left = fetch_pixel(index - record_width, last_row)

          pr = paeth_predictor( left, above, upper_left )
          (value - pr) % 256
        else
          raise "We can currently only encode to PAETH or type 0. Filter type (#{filter_type}) is not supported"
        end
      end

      private

      def paeth_predictor( left, above, upper_left )
        p = left + above - upper_left
        pa = (p - left).abs
        pb = (p - above).abs
        pc = (p - upper_left).abs

        pr = upper_left
        if ( pa <= pb and pa <= pc)
          pr = left
        elsif (pb <= pc)
          pr = above
        end
        pr
      end
    end
  end
end
