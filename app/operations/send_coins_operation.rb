class SendCoinsOperation < BaseOperation
  include Bitcoin::Builder

  def initialize(private_key, recipient, amount)
    @key = Bitcoin::Key.new(private_key)
    @address = @key.addr
    @balance = GetBalanceOperation.(@address)
    @recipient = recipient
    @amount = amount
    @total = amount + Transaction::NETWORK_FEE
  end

  def call
    broadcast_transaction
  end

  private

  attr_reader :key, :address, :balance, :recipient, :amount, :total

  def broadcast_transaction
    response = HTTP.post(broadcast_url, body: tx.to_payload.unpack('H*')[0])
    response.body.to_s if response.status.success?
  end

  def tx
    build_tx do |t|
      utxos.each do |utxo|
        t.input do |i|
          i.prev_out prev_tx(utxo[:txid])
          i.prev_out_index utxo[:vout]
          i.signature_key key
        end
      end

      t.output do |o|
        o.value convert_btc_to_satoshis(amount)
        o.script {|s| s.recipient recipient }
      end

      t.output do |o|
        o.value convert_btc_to_satoshis(balance - total)
        o.script {|s| s.recipient address }
      end
    end
  end

  def prev_tx(txid)
    url = "#{BLOCKSTREAM_API_BASE_URL}/tx/#{txid}/raw"
    response = HTTP.get(url)

    Bitcoin::P::Tx.new(response.body.to_s)
  end

  def broadcast_url
    "#{BLOCKSTREAM_API_BASE_URL}/tx"
  end

  def convert_btc_to_satoshis(btc)
    btc * SATOSHIS_IN_BTC
  end
end
