require 'spec_helper'

describe BrainstemAdaptor do
  describe '.parser=' do
    let(:parser) { double('real parser', parse: true) }

    specify do
      expect { described_class.parser = parser }.to change(described_class, :parser).to(parser)
    end

    specify do
      expect { described_class.parser = double('something wrong') }.to raise_error ArgumentError
    end
  end

  describe '.parser' do
    it 'users JSON parser by default' do
      expect { described_class.parser }.not_to raise_error
    end
  end

  describe '.default_specification' do
    specify do
      expect { described_class.default_specification }.not_to raise_error
    end
  end

  describe '.specification=' do
    let(:specification) { {users: {}} }

    specify do
      expect { described_class.specification = specification }.to change(described_class, :default_specification).to(specification)
    end
  end
end
