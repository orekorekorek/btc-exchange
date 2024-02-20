require 'rails_helper'

RSpec.describe GetBalanceOperation do
  subject(:call) { described_class.call('mjrFHUTszcjByUjVQ7gRiB2BVkyJUNe6NS') }

  around do |example|
    VCR.use_cassette('get_utxos') do
      example.run
    end
  end

  describe '#call' do
    it 'returns balance by address as sum of utxos values' do
      expect(call).to be_a(Float)
    end
  end
end
