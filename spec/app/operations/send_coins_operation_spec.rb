require 'rails_helper'

RSpec.describe SendCoinsOperation do
  let(:operation) do
    described_class.new(
      '7cfbcb519318b7b0960e03fcfc346e6dd5bf740da58070f341630d9ea3a0af82',
      'mrXfk2NNR2wgg6RQerdh5F5LFa98rTML6M',
      0.0001
    )
  end

  before do
    VCR.use_cassette('broadcast_transaction') do
      @txid = operation.call
    end
  end

  describe '#call' do
    it 'broadcasts transaction' do
      expect(@txid).to be_a(String)
    end
  end
end
