require 'spec_helper'

describe BrainstemAdaptor::Specification do
  describe '.[]' do
    before do
      described_class[:test] = {stored: true}
    end

    specify do
      expect(described_class[:test]).to eq({stored: true})
    end
  end
end