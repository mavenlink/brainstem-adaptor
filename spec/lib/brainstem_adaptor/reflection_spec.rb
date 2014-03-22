require 'spec_helper'

describe BrainstemAdaptor::Reflection do
  describe '#==' do
    specify do
      expect(subject).to eq(subject)
    end
  end
end