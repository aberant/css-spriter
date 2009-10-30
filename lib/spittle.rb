require 'zlib'

$:.unshift( File.dirname( __FILE__ ))

require 'spittle/file_header'
require 'spittle/parser'
require 'spittle/filters'
require 'spittle/chunk'
require 'spittle/ihdr'
require 'spittle/idat'
require 'spittle/iend'
require 'spittle/image'

