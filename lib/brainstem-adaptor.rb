require 'yaml'
require 'json'
require 'brainstem_adaptor/specification'
require 'brainstem_adaptor/association'
require 'brainstem_adaptor/record'
require 'brainstem_adaptor/invalid_response_error'
require 'brainstem_adaptor/response'

module BrainstemAdaptor
  VERSION = '0.0.1'

  def self.parser
    @parser ||= JSON
  end

  # @param parser Any JSON parser
  # @raise [ArgumentError] if parser does not respond to #parse
  def self.parser=(parser)
    raise ArgumentError, 'Parser must respond to #parse message' unless parser.respond_to?(:parse)
    @parser = parser
  end

  # @return [BrainstemAdaptor::Specification]
  def self.default_specification
    BrainstemAdaptor::Specification[:default]
  end

  # @param specification [Hash]
  def self.specification=(specification)
    BrainstemAdaptor::Specification[:default] = specification
  end

  # @param path [String] Path to YML specification file
  def self.load_specification(path)
    self.specification = YAML::load_file(path)
  end
end