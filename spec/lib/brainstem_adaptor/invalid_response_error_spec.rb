require 'spec_helper'

describe BrainstemAdaptor::InvalidResponseError do
  subject { described_class.new(response) }
  let(:response) { {failed: true} }

  its(:response) { should == response }
  its(:message) { should include('failed') }

  specify do
    expect { raise BrainstemAdaptor::InvalidResponseError, 'failed' }.to raise_error(described_class)
  end
end