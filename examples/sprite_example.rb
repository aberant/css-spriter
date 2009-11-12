require File.join( File.dirname( __FILE__ ), '..', 'lib', 'spittle' )

cat = PNG::Image.open( "pic_data/cat.png" )
dog = PNG::Image.open( "pic_data/dog.png" )
trash = PNG::Image.open( "pic_data/trash.png" )

sprite = PNG::Sprite.new
sprite.append cat
sprite.append dog
sprite.append trash
sprite.write( "pic_data/animal.png")
