require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PNG::Header do
  # the pnd header provides sanity checks against most common file transfer errrors
  it "outputs the PNG header" do
    header = PNG::Header.new.encode
    header.should == [137, 80, 78, 71, 13, 10, 26, 10].pack("C*")
  end
end

