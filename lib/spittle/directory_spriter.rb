class DirectoryProcessor

  DEFAULT_TEMPLATE = <<-EOF
  .<name>_<image_name> {
    background: transparent url(<image_loc>) <offset>px 0px no-repeat;
    width:<width>;
    height:<height>;
    text-indent:-5000px;
  }

  EOF

  def initialize(dir, options = {})
    @options = options
    @dir = dir
    files = images
    @sprite = PNG::Sprite.new
    files.each {|f| @sprite.append(PNG::Image.open(f))}
    #puts "#{@dir} #{files.size} files"
    @tracker = MtimeTracker.new(@dir,
                                :exclude => ['fragment.css', 'sprite.png'])
  end

  def images
    Dir.glob(@dir + "/*.png").reject{|i| i.match /sprite\.png/}
  end

  def write
    return unless @tracker.has_changes?
    @sprite.write(sprite_file)
    File.open(css_file, 'w') do |f|
      f.write(css)
    end
    @tracker.update
  end

  def cleanup
    File.delete(sprite_file) rescue {}
    File.delete(css_file) rescue {}
    @tracker.cleanup
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

  def image_loc
    #TODO: Lame!
    base = ("/" + @dir + "/sprite.png").gsub("/./", "/").gsub("//", "/")
    base = @options[:path_prefix] + base if @options[:path_prefix]
    base
  end

  def template_file
    @dir + "/template.css"
  end

  def template
    if File.exists?(template_file)
      return File.read(template_file)
    end
    return DEFAULT_TEMPLATE
  end

  def css
    @sprite.locations.inject("") do |out, image|
      image_name, properties = image
      out << template.gsub("<name>", dir_name).
             gsub("<image_name>", image_name.to_s).
             gsub("<width>", properties[:width].to_s).
             gsub("<height>", properties[:height].to_s).
             gsub("<offset>", properties[:x].to_s).
             gsub("<image_loc>", image_loc)
    end
  end
end
