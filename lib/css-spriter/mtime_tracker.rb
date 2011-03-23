module CssSpriter
  class MtimeTracker
    def initialize(dir, options = {})
      @dir = dir
      @options = options
    end

    def cleanup
      File.delete(mtime_file) rescue nil
    end

    def fresh?
      not File.exists?(mtime_file)
    end

    def files
      @files = without_exclusions(Dir.glob(@dir + "/**/*"))
    end

    def without_exclusions(files)
      return files unless @options[:exclude]
      exclusions = [@options[:exclude]].flatten
      files.select{|f| not exclusions.any?{|e| f.match e}}
    end

    def current_mtimes
      @current ||= files.inject({}) do |map, f|
        map[f] = File.mtime(f).to_i; map
      end
    end

    def file_changed?(file)
      mtimes[file] != current_mtimes[file]
    end

    def mtimes
      return @mtimes if @mtimes
      return {} unless File.exists?(mtime_file)
      @mtimes = read_mtimes
    end

    def read_mtimes
      mtimes = {}
      File.open(mtime_file) do |f|
        f.each do |line|
          name, time = line.split("\t")
          mtimes[name] = time.to_i
        end
      end
      mtimes
    end

    def changeset
      changed = files.select{|f| file_changed?(f)}
      deleted = without_exclusions(mtimes.keys) - current_mtimes.keys
      changed + deleted
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
end