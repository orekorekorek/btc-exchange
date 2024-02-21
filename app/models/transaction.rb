class Transaction < ApplicationRecord
  NETWORK_FEE = 0.000006
  EXCHANGE_FEE_PERCENTAGE = 0.03
  MAX_USDT_PER_TRANSACTION = 30

  enum status: { fail: 0, success: 1 }
end
