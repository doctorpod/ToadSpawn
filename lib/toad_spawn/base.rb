module ToadSpawn
  class Base
    def initialize(path)
      raise "Directory does not exist" unless File.exist?(path)
      raise "Not a directory" unless File.directory?(path)
      raise "Not writable" unless File.writable?(path)
      @path = path
      flush
    end
    
    def key_file_path(key)
      File.join(@path, key.to_s + ".value")
    end
    
    def format(key, value)
      "#{value.class}\n#{value}"
    end
    
    def klass(data)
      data[/^(.+)\n/,1]
    end
    
    def value(data)
      data.sub(/^.+\n/,'')
    end
    
    def cast(value, klass)
      case klass
      when 'Fixnum'
        value.to_i
      when 'Float'
        value.to_f
      else
        value.to_s
      end
    end
    
    def []=(key, value)
      File.open(key_file_path(key), "w") do |f|
        f.write format(key, value)
      end
      @cache[key] = cast(value, value.class.to_s)
    end
    
    def read_file(path)
      data = File.read(path)
      [File.basename(path, ".value").to_sym, cast(value(data), klass(data))]
    end
    
    def [](key)
      @cache[key]
    end
    
    def flush
      @cache = {}
      Dir.glob("#{@path}/*.value").each do |path|
        key, value = read_file(path)
        @cache[key] = value
      end
    end
    
    def to_hash
      @cache
    end
    
    def any?
      @cache.any?
    end
    
    def empty?
      @cache.empty?
    end
    
    def delete(key)
      File.delete key_file_path(key)
      @cache.delete(key)
    end
    
    def has_key?(key)
      @cache.has_key?(key)
    end
    
    def has_value?(value)
      @cache.has_value?(value)
    end
    
    def keys
      @cache.keys
    end
    
    def values
      @cache.values
    end
    
    def size
      @cache.size
    end
    
    def clear
      Dir.glob("#{@path}/*.value").each do |path|
        File.delete(path)
      end
      @cache = {}
    end
  end
end