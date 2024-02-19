require 'bitcoin'

class TransactionCreateForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email, :string
  attribute :address, :string
  attribute :txid, :string
  attribute :amount_base, :decimal
  attribute :exchange_rate, :decimal
  attribute :status, :string
  attribute :base, :string
  attribute :target, :string
  attribute :terms, :boolean

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :check_address
  validates :amount_base,
            numericality: {
              greater_than: 0,
              less_than_or_equal_to: Transaction::MAX_USDT_PER_TRANSACTION
            }
  validates :amount_target,
            numericality: {
              greater_than: 0,
              less_than_or_equal_to: -> (form) { form.btc_upper_bound }
            }
  validates :terms, presence: true
  validate :check_currency

  def call
    return unless valid?

    self.txid = SendCoinsOperation.(private_key, address, amount_target)
    self.status = txid.present? ? 'success' : 'fail'
    Transaction.create!(transaction_params)
  end

  def btc_upper_bound
    btc = Transaction::MAX_USDT_PER_TRANSACTION * exchange_rate

    (1 - Transaction::EXCHANGE_FEE_PERCENTAGE) * btc - Transaction::NETWORK_FEE
  end

  def exchange_fee
    return unless amount_base

    (Transaction::EXCHANGE_FEE_PERCENTAGE * amount_base * exchange_rate).round(8)
  end

  def amount_target
    return unless exchange_fee

    (amount_base * exchange_rate - exchange_fee - Transaction::NETWORK_FEE).round(8)
  end

  private

  def transaction_params
    {
      email: email,
      address: address,
      amount_base: amount_base,
      amount_target: amount_target,
      base: base,
      target: target,
      exchange_rate: exchange_rate,
      exchange_fee: exchange_fee,
      txid: txid,
      status: status
    }
  end

  def check_address
    errors.add(:address, 'is invalid') unless Bitcoin.valid_address?(address)
  end

  def check_currency
    errors.add(:exchange_rate, 'is old') unless exchange_rate == current_rate
    self.exchange_rate = current_rate
  end

  def current_rate
    @current_rate ||= CurrentRateService.new.call
  end

  def private_key
    ENV.fetch('WALLET_PRIVATE_KEY')
  end
end
