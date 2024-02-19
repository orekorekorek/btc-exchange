require 'rails_helper'

RSpec.describe TransactionCreateForm, type: :model do
  subject(:form) { described_class.new(form_params) }

  around do |example|
    env_key = ENV['WALLET_PRIVATE_KEY']
    ENV['WALLET_PRIVATE_KEY'] = '7cfbcb519318b7b0960e03fcfc346e6dd5bf740da58070f341630d9ea3a0af82'

    VCR.use_cassette('create_transaction') do
      example.run
    end

    ENV['WALLET_PRIVATE_KEY'] = env_key
  end

  let(:form_params) do
    {
      email: 'bitcoin666@gtm.com',
      address: 'mjrFHUTszcjByUjVQ7gRiB2BVkyJUNe6NS',
      amount_base: 10,
      exchange_rate: 0.00001922,
      base: 'UST',
      target: 'BTC',
      terms: true
    }
  end

  describe 'validations' do
    it { is_expected.to allow_value('abacaba@aba.com').for(:email) }
    it { is_expected.not_to allow_value('abacabacom').for(:email) }

    it { is_expected.to allow_value(15.0).for(:amount_base) }
    it { is_expected.not_to allow_value(31).for(:amount_base) }
    it { is_expected.not_to allow_value(-3).for(:amount_base) }

    it { is_expected.to validate_presence_of(:terms) }
  end

  describe '#check_address' do
    context 'with valid receipient address' do
      it 'is valid' do
        expect(form).to be_valid
      end
    end

    context 'with invalid receipient address' do
      let(:form_params) { super().merge(address: 'fake_addresss') }

      it 'is not valid' do
        expect(form).not_to be_valid
      end
    end
  end

  describe '#call' do
    it 'returns transaction' do
      expect(form.call).to be_a(Transaction)
    end
  end
end
