module TransactionHelper
  def present_btc(value)
    return unless value

    sprintf("%.8f", value)
  end

  def present_ust(value)
    return unless value

    sprintf("%.2f", value)
  end

  def present_network_fee
    present_btc(Transaction::NETWORK_FEE)
  end

  def present_amount_base(transaction)
    present_ust(transaction.amount_base)
  end

  %w[amount_target exchange_rate exchange_fee].each do |field|
    define_method("present_#{field}") do |transaction|
      present_btc(transaction.send(field))
    end
  end
end
