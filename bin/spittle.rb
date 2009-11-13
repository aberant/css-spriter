#!/usr/local/bin/ruby

require File.dirname(__FILE__) + "/../lib/spittle.rb"

dir = ARGV[0]
p = Spittle::Processor.new(:source => dir)
p.write
