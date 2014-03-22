module BrainstemAdaptor
  class Reflection
    include Enumerable

    attr_reader :name, :record, :specification

    # @param record [BrainstemAdaptor::Record]
    # @param name [String, Symbol]
    def initialize(record, name)
      unless record.has_association?(name)
        raise ArgumentError, "No '#{name}' specification found for #{record.collection_name}"
      end

      @record = record
      @specification = record.associations_specification[name]
      @name = name.to_s
    end

    # @return [Enumerable]
    def each(&block)
      records.each(&block)
    end

    # @return [Array<BrainstemAdaptor::Record>]
    def records
      record[specification['foreign_key']].map do |id|
        BrainstemAdaptor::Record.new(name, id, record.response)
      end
    end
  end
end