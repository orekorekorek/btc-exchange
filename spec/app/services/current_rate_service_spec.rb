require 'rails_helper'

RSpec.describe CurrentRateService do
  let(:service) { described_class.new }

  before do
    VCR.use_cassette('usdt_to_btc_rate') do
      @rate = service.call
    end
  end

  describe '#call' do
    it 'returns current rate' do
      expect(@rate).to be_a(Float)
    end
  end
end
