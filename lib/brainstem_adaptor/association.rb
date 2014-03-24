module BrainstemAdaptor
  class Association
    include Enumerable

    attr_reader :name, :record, :specification, :collection_name, :foreign_key

    # @param record [BrainstemAdaptor::Record]
    # @param name [String, Symbol]
    def initialize(record, name)
      @name = name.to_s

      unless record.has_association?(@name)
        raise ArgumentError, "No '#@name' specification found for #{record.collection_name}"
      end

      @record          = record
      @specification   = record.associations_specification[@name]
      @collection_name = @specification['collection'] || @name
      @foreign_key     = @specification['foreign_key']
    end

    # @param other [Enumerable]
    # @return [true, false]
    def ==(other)
      other == each.to_a
    end

    # @param order [Integer] Index in collection starting from zero
    def [](order)
      records[order]
    end

    # @return [Enumerable]
    def each(&block)
      records.each(&block)
    end

    def has_many?
      ids.is_a?(Array)
    end

    def has_one?
      !has_many?
    end

    # Checks if association has been included in request
    # @return [true, false]
    def loaded?
      !record[foreign_key].nil?
    end

    # @return [Array<BrainstemAdaptor::Record>]
    def records
      [*ids].map do |id|
        BrainstemAdaptor::Record.new(collection_name, id, record.response)
      end
    end
    alias_method :all, :records

    # Returns relation object for has_many associations and record for has_one
    # Acts as AR::find for has_one associations, as AR::where for has_many
    # @return [BrainstemAdaptor::Record, self]
    def reflect
      has_many? ? self : records.first
    end

    private

    def ids # TODO(SZ): move to public?
      record[foreign_key]
    end
  end
end
