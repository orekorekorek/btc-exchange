export const toggleRate = (el) => {
  const exchangeFeePercentage = 0.03
  const networkFee = 0.000006
  const base = el.querySelector("#transaction_create_form_amount_base")
  const target = el.querySelector("#transaction_create_form_amount_target")
  const exchangeRate = el.querySelector("#transaction_create_form_exchange_rate")
  const exchangeFee = el.querySelector("#transaction_create_form_exchange_fee")

  const updateTarget = () => {
    const baseInBtc = (1 - exchangeFeePercentage) * +base.value * +exchangeRate.value - networkFee
    if (baseInBtc > 0) {
      target.value = baseInBtc.toFixed(8).toLocaleString({useGrouping:false})
    } else {
      target.value = 0
    }
    const fee = exchangeFeePercentage * +base.value * +exchangeRate.value
    exchangeFee.value = fee.toFixed(8).toLocaleString({useGrouping:false})
  }

  const updateBase = () => {
    const targetInUst = (+target.value + networkFee) / ((1 - exchangeFeePercentage) * +exchangeRate.value)
    base.value = +targetInUst.toFixed(2).toLocaleString({useGrouping:false})
    const fee = exchangeFeePercentage * +base.value * +exchangeRate.value
    exchangeFee.value = fee.toFixed(8).toLocaleString('fullwide', {useGrouping:false})
  }

  base.addEventListener("input", updateTarget)

  target.addEventListener("input", updateBase)

  el.addEventListener("load", updateTarget)
}
