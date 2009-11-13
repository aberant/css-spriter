#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../lib/spittle.rb"

dir = ARGV[0]
raise "a directory must be specified" unless dir

Spittle::Processor.new(:source => dir).write
