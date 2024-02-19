class CurrentRateService
  EXCHANGE_RATE_API_URL = 'https://api-pub.bitfinex.com/v2/calc/fx'.freeze

  def initialize(base: 'UST', target: 'BTC')
    @base = base
    @target = target
  end

  def call
    response = HTTP.post(EXCHANGE_RATE_API_URL, body: body.to_json, headers: { 'Content-Type' => 'application/json' })
    return unless response.status.success?

    JSON.parse(response.body)[0]
  end

  private

  attr_reader :base, :target

  def body
    {
      ccy1: base,
      ccy2: target
    }
  end
end
