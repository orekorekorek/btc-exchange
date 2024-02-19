class GetBalanceOperation < BaseOperation
  def initialize(address)
    @address = address
  end

  def call
    satoshis = get_utxos.sum { |utxo| utxo[:value] }
    convert_satoshis_to_btc(satoshis)
  end

  private

  attr_reader :address
end
