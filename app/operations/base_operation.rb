require 'bitcoin'
require 'http'

class BaseOperation
  include Callable

  BLOCKSTREAM_API_BASE_URL = 'https://blockstream.info/testnet/api'.freeze
  SATOSHIS_IN_BTC = 100_000_000

  def call
    raise NotImplementedError
  end

  private

  def utxos
    @utxos ||= get_utxos
  end

  def get_utxos
    response = HTTP.get(utxos_url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def utxos_url
    "#{BLOCKSTREAM_API_BASE_URL}/address/#{address}/utxo"
  end

  def address
    raise NotImplementedError
  end

  def convert_satoshis_to_btc(satoshis)
    satoshis.to_f / SATOSHIS_IN_BTC
  end
end
