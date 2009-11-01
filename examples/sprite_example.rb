require File.join( File.dirname( __FILE__ ), '..', 'lib', 'spittle' )

one = PNG::Image.open( "pic_data/png_test.png" )

sprite = PNG::Sprite.new
sprite.merge_right one
sprite.merge_right one
sprite.merge_right one

sprite.write( "pic_data/sprite_test.png" )
