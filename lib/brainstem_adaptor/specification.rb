module BrainstemAdaptor
  class Specification < Hash

    # @param specification [Hash]
    def initialize(specification)
      super
      self.merge!(specification)
    end

    # @return [Hash]
    def self.instances
      @instances ||= {}
    end

    # @param key [Symbol] Specification name
    # @return [BrainstemAdaptor::Specification]
    def self.[](key)
      self.instances[key.to_sym] or raise ArgumentError, "No such specification '#{key}'"
    end

    # @param key [Symbol] Specification name
    # @param value [Hash] Specification body
    def self.[]=(key, value)
      self.instances[key.to_sym] = self.new(value)
    end
  end
end