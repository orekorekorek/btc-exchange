require 'rails_helper'

RSpec.describe GetBalanceOperation do
  before do
    VCR.use_cassette('get_utxos') do
      @balance = described_class.call('mjrFHUTszcjByUjVQ7gRiB2BVkyJUNe6NS')
    end
  end

  describe '#call' do
    it 'returns balance by address as sum of utxos values' do
      expect(@balance).to be_a(Float)
    end
  end
end
