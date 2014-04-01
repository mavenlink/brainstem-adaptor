module BrainstemAdaptor
  class Record < ActiveSupport::HashWithIndifferentAccess
    attr_reader :collection_name, :id, :response

    # @param collection_name [String, Symbol]
    # @param id
    # @param response [BrainstemAdaptor::Response, nil]
    def initialize(collection_name, id, response = nil)
      super([])
      @collection_name = collection_name.to_s
      @id = id
      load_fields_with(response) if response
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
    # @raise [ArgumentError] if name is not related to any association
    # @return [BrainstemAdaptor::Association]
    def association_by_name(name)
      if has_association?(name)
        (@associations ||= {})[name] ||= BrainstemAdaptor::Association.new(self, name)
      end
    end

    # @param name [String]
    def has_association?(name)
      associations_specification.has_key?(name.to_s)
    end

    # @return [Hash]
    def specification
      @specification ||= {}
    end

    protected

    # @param response [Brainstem::Response]
    # @param fields_to_reload [Array] Reloads all fields if empty
    def load_fields_with(response, fields_to_reload = [])
      @response = response

      if @response.specification.has_key?(collection_name)
        @specification = @response.specification[collection_name] || {}
      else
        raise BrainstemAdaptor::InvalidResponseError, "Can't find '#{collection_name}' association in specification"
      end

      collection = @response[@collection_name] or
        raise BrainstemAdaptor::InvalidResponseError, "No such collection #@collection_name"

      fields = collection[@id] or
        raise BrainstemAdaptor::InvalidResponseError, "No such record #{@collection_name}##{@id}"

      if fields_to_reload.any?
        merge!(fields.slice(*fields_to_reload))
      else
        merge!(fields)
      end
    end
  end
end
