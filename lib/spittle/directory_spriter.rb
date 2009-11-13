class DirectoryProcessor
  def initialize(dir)
    @dir = dir
    files = images
    @sprite = PNG::Sprite.new
    files.each {|f| @sprite.append(PNG::Image.open(f))}
  end

  def images
    Dir.glob(@dir + "/*.png").reject{|i| i.match /sprite\.png/}
  end

  def write
    @sprite.write(sprite_file)
    File.open(css_file, 'w') do |f|
      f.write(css)
    end
  end

  def cleanup
    File.delete(sprite_file) rescue {}
    File.delete(css_file) rescue {}
  end

  def sprite_file
    @dir + "/sprite.png"
  end

  def css_file
    @dir + "/fragment.css"
  end

  def dir_name
    @dir.split('/').last
  end

  FRAG = <<-EOF
  .<name>_<image_name> {
    background: transparent url(<image_loc>) <offset>px 0px no-repeat;
    width:<width>;
    text-indent:-5000px;
  }

  EOF

  def css
    @sprite.locations.inject("") do |out, image|
      image_name, properties = image
      out << FRAG.gsub("<name>", dir_name).
             gsub("<image_name>", image_name.to_s).
             gsub("<width>", properties[:width].to_s).
             gsub("<offset>", properties[:x].to_s).
             gsub("<image_loc>", "/" + @dir + "/sprite.png")
    end
  end
end
