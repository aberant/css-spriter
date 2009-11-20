class MtimeTracker
  def initialize(dir, options = {})
    @dir = dir
    @options = options
  end

  def cleanup
    File.delete(mtime_file) rescue {}
  end

  def fresh?
    not File.exists?(mtime_file)
  end

  def files
    return @files if @files
    @files = without_exclusions(Dir.glob(@dir + "/**/*"))
  end

  def without_exclusions(files)
    return files unless @options[:exclude]
    exclusions = [@options[:exclude]].flatten
    files.select{|f| exclusions.none?{|e| f.match e}}
  end

  def current_mtimes
    @current ||= files.inject({}) do |map, f|
      map[f] = File.mtime(f).to_i; map
    end
  end

  def file_changed?(file)
    #puts "#{file} #{mtimes[file]} != #{current_mtimes[file]}"
    mtimes[file] != current_mtimes[file]
  end

  def mtimes
    return @mtimes if @mtimes
    return {} unless File.exists?(mtime_file)
    @mtimes = {}
    File.open(mtime_file) do |f|
      f.each do |line|
        parts = line.split("\t")
        @mtimes[parts[0]] = parts[1].to_i
      end
    end
    @mtimes
  end

  def changeset
    files.select{|f| file_changed?(f)}
  end

  def has_changes?
    not changeset.empty?
  end
  
  def mtime_file
    @dir + "/.mtimes"
  end

  def update
    File.open(mtime_file, 'w') do |f|
      current = current_mtimes
      flat = current.map{|k, v| "#{k}\t#{v}\n"}.join
      f.write flat
    end
    reset
  end

  def reset
    @mtimes = nil
    @current = nil
    @files = nil
  end
end
