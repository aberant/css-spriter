require File.join( File.dirname( __FILE__ ), '..', 'lib', 'spittle' )

one = PNG::Image.open( "pic_data/png_test.png" )
two = PNG::Image.open( "pic_data/png_test_inverted.png" )

sprite = PNG::Sprite.new
sprite.merge_right one
sprite.merge_right two

sprite.write( "pic_data/sprite_test.png" )
