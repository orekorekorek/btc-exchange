require 'rails_helper'

RSpec.describe SendCoinsOperation do
  let(:call) do
    described_class.new(
      'cRmerC6e29tDiepNnNzFJN6PJuxXedf9CZFJYBk8PzAp3wXeDnno',
      'mrXfk2NNR2wgg6RQerdh5F5LFa98rTML6M',
      0.0001
    ).call
  end

  around do |example|
    VCR.use_cassette('broadcast_transaction') do
      example.run
    end
  end

  describe '#call' do
    it 'broadcasts transaction' do
      expect(call).to be_a(String)
    end
  end
end
