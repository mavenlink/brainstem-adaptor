module BrainstemAdaptor
  class Specification < Hash
    def self.instances
      @instances ||= {}
    end

    def self.[](key)
      self.instances[key.to_sym]
    end

    def self.[]=(key, value)
      self.instances[key.to_sym] = self.new.merge!(value)
    end
  end
end