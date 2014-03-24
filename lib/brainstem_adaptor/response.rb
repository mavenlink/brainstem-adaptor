module BrainstemAdaptor
  class Response
    attr_reader :response_data, :specification

    # @param response_data [String, Hash]
    # @param specification [BrainstemAdaptor::Specification]
    def initialize(response_data, specification = BrainstemAdaptor.default_specification)
      @specification = specification or raise ArgumentError, 'Specification is not set'

      case response_data
      when String
        @response_data = BrainstemAdaptor.parser.parse(response_data)
      when Hash
        @response_data = response_data
      else
        raise ArgumentError, "Expected String, got #{@response_data.class.name}"
      end

      raise InvalidResponseError, "count isn't returned" unless @response_data['count']
      raise InvalidResponseError, "results collection isn't returned" unless @response_data['results']

    rescue JSON::ParserError => e
      raise BrainstemAdaptor::InvalidResponseError, response_data, e.message
    end

    # @param key [String, Symbol]
    # @return [Hash, nil]
    def [](key)
      response_data[key.to_s]
    end

    # Returns __TOTAL__ number of records
    # @return [Integer]
    def count
      response_data['count']
    end
    alias_method :total_count, :count

    # @return [String]
    def to_hash
      response_data
    end

    # Returns results has with proper ordering
    # @return [Array<BrainstemAdaptor::Record>]
    def results
      self['results'].map do |result|
        BrainstemAdaptor::Record.new(result['key'], result['id'], self)
      end
    end
  end
end
