#!/usr/bin/env ruby
require 'webrick'

Socket.do_not_reverse_lookup = true # patch for OS X
params = { :Port => 3000, :DocumentRoot => '.'}

server = WEBrick::HTTPServer.new(params)
trap("INT") { server.shutdown }
server.start

