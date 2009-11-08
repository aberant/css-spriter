module PNG
  class Filters
    #TODO: feature envy, this behavior belongs to a row. 
    def self.fetch_pixel(idx, row)
      return 0 if idx < 0
      return row[idx] || 0
    end

    def self.[]( filter_num )
      FILTERS[ filter_num ]
    end

    NONE = lambda {|value, index, row, last_row, record_width| value}
    LEFT = lambda {|value, index, row, last_row, record_width|
             (value + fetch_pixel(index - record_width, row)) % 256
           }
    UP  = lambda {|value, index, row, last_row, record_width|
             (value + fetch_pixel(index, last_row)) % 256
           }
    AVG  = lambda {|value, index, row, last_row, record_width| 
             (value + ( (fetch_pixel(index - record_width, row) + fetch_pixel(index, last_row)) / 2 ).floor) % 256
           }
    PAETH  = lambda {|value, index, row, last_row, record_width| 
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
             }

    FILTERS = {0 => NONE,
               1 => LEFT, 
               2 => UP,
               3 => AVG,
               4 => PAETH}

  end
end
