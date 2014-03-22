module BrainstemAdaptor
  class Record < Hash
    attr_reader :collection_name, :id, :response

    # @param collection_name [String, Symbol]
    # @param id
    # @param response [BrainstemAdaptor::Response, nil]
    def initialize(collection_name, id, response = nil)
      @collection_name = collection_name.to_s
      @id = id
      @response = response

      collection = response[@collection_name] or
        raise BrainstemAdaptor::InvalidResponse, "No such collection #@collection_name"

      fields = collection[@id] or
        raise BrainstepAdaptor::InvalidResponse, "No such record #{@collection_name}##{@id}"

      merge!(fields)
    end

    # @param key [String]
    def [](key)
      if has_key?(key = key.to_s)
        super
      elsif has_association?(key)
        association_by_name(key).reflect
      end
    end

    # @return [Hash]
    def associations_specification
      @associations_specification ||= specification['associations'] || {}
    end

    # @param name [String]
    def has_association?(name)
      associations_specification.has_key?(name.to_s)
    end

    private

    # @param name [String]
    # @raise [ArgumentError] if name is not related to any association
    # @return [BrainstemAdaptor::Reflection]
    def association_by_name(name)
      (@associations ||= {})[name] ||= BrainstemAdaptor::Reflection.new(self, name)
    end

    # @return [Hash]
    def specification
      @response.specification[collection_name]
    end
  end
end