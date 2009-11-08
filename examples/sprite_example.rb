require File.join( File.dirname( __FILE__ ), '..', 'lib', 'spittle' )

cat = PNG::Image.open( "pic_data/cat.png" )
dog = PNG::Image.open( "pic_data/dog.png" )
trash = PNG::Image.open( "pic_data/trash.png" )

sprite = PNG::Sprite.new
sprite.merge_right cat
sprite.merge_right dog
sprite.merge_right trash
sprite.write( "pic_data/animal.png")
