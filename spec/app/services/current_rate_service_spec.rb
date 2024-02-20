require 'rails_helper'

RSpec.describe CurrentRateService do
  let(:call) { described_class.new.call }

  around do |example|
    VCR.use_cassette('usdt_to_btc_rate') do
      example.run
    end
  end

  describe '#call' do
    it 'returns current rate' do
      expect(call).to be_a(Float)
    end
  end
end
