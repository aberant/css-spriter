module PNG
  class Header
   def encode
     [137, 80, 78, 71, 13, 10, 26, 10].pack("C*")
   end
  end
end