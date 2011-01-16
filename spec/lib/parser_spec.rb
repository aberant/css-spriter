require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'stringio'

describe PNG::Parser do
  it "errors out when the file header is wrong" do
    bad_header = [5, 80, 78, 71, 13, 10, 26, 10].pack("C*")
    file = StringIO.new( bad_header)

    lambda {
      Parser.go!( file )
    }.should raise_error
  end
end
