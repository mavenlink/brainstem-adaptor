require 'json'
require 'brainstem_adaptor/specification'
require 'brainstem_adaptor/reflection'
require 'brainstem_adaptor/record'
require 'brainstem_adaptor/invalid_response'
require 'brainstem_adaptor/response'

module BrainstemAdaptor

  def self.parser
    @parser ||= JSON
  end

  def self.parser=(parser)
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
end