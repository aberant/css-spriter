require File.join( File.dirname( __FILE__ ), '..', 'lib', 'spittle' )

png = PNG::Image.open("pic_data/png_test.png")
two = PNG::Image.open("pic_data/png_test.png")
out = png.merge_left(two)

out.write("pic_data/out.png")

png.write('pic_data/test.png')

`open pic_data/out.png`