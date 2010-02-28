# horrible place for this.  just a sanity check for filtering

require File.join( File.dirname( __FILE__ ), '..', 'lib', 'css-spriter' )

image = PNG::Image.open( "sprites/many_sized_cats/darth_cat.png")

5.times do |i|
  puts i
  image.write("bob-filter-#{i}.png", :filter_type => i)
end

5.times do |i|
  filename = "bob-filter-#{i}.png"
  puts "filter #{i}: #{File.size( filename )}"
  File.delete( filename )
end

