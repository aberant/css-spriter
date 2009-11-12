class DirectorySpriter
  def initialize(dir)
    @dir = dir
    files = images
    @sprite = PNG::Sprite.new
    files.each {|f| @sprite.append(PNG::Image.open(f))}
  end

  def images
    Dir.glob(@dir + "/*.png").reject{|i| i.match /sprite\.png/}
  end

  def process
    @sprite.write(@dir + "/sprite.png")
    File.open(@dir + "/fragment.css", 'w') do |f|
      f.write(css)
    end
  end

  def dir_name
    @dir.split('/').last
  end

  FRAG = <<-EOF
  .<name>_<image_name> {
    background: transparent url(<image_loc>)<offset>px 0px no-repeat;
    width:<width>;
  }

  EOF

  def css
    locations = @sprite.locations
    out = ""
    locations.each do |image_name, properties|
      out << FRAG.gsub("<name>", dir_name).
             gsub("<image_name>", image_name.to_s).
             gsub("<width>", properties[:width].to_s).
             gsub("<offset>", properties[:x].to_s).
             gsub("<image_loc>", @dir + "/sprite.png")
    end
    out
  end
end
