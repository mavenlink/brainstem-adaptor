module BrainstemAdaptor
  class Response
    attr_reader :response_data, :specification

    # @param json_response [String]
    # @param specification [BrainstemAdaptor::Specification]
    def initialize(json_response, specification = BrainstemAdaptor.default_specification)
      @response_data = BrainstemAdaptor.parser.parse(json_response)
      @specification = specification
    end

    # @param key [String, Symbol]
    # @return [Hash, nil]
    def [](key)
      @response_data[key.to_s]
    end

    # Returns response collection by name
    # @return [Array<BrainstemAdaptor::Record>]
    def collection(name)
      self[name].keys.map do |id|
        BrainstemAdaptor::Record.new(name, id, self)
      end
    end

    # @return [Integer]
    def count
      self[:count]
    end

    # Returns results has with proper ordering
    # @return [Array<BrainstemAdaptor::Record>]
    def results
      self[:results].map do |result|
        BrainstemAdaptor::Record.new(result['key'], result['id'], self)
      end
    end
  end
end