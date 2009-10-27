require File.join( File.dirname( __FILE__ ), '..', 'lib', 'spittle' )

png = PNG.open("pic_data/png_test.png")
two = PNG.open("pic_data/png_test.png")
out = png.merge_right(two)
out.write("pic_data/out.png")