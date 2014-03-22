module BrainstemAdaptor
  class Specification < Hash
    def self.instances
      @instances ||= {}
    end

    def self.[](key)
      instances[key.to_sym]
    end

    def self.[]=(key, value)
      instances[key.to_sym] = self.new(value)
    end
  end
end