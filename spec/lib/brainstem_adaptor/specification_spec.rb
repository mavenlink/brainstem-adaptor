require 'spec_helper'

describe BrainstemAdaptor::Specification do
  describe '.[]' do
    before do
      described_class[:test] = {stored: true}
      described_class[:another_test] = {something_else: false}
    end

    it 'stores multiple specifications' do
      expect(described_class[:test]).to eq({stored: true})
      expect(described_class[:another_test]).to eq({something_else: false})
    end
  end
end