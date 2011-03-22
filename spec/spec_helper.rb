require 'rspec'
require 'rspec/autorun'

require 'chunky_png'
require 'css-spriter'


require 'builders/image_builder'

RSpec.configure do |config|

end

def chunk(type, data)
  to_check = type + data
  [data.length].pack("N") + to_check + [Zlib.crc32(to_check)].pack("N")
end
