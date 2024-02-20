// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "./controllers"
import { toggleRate } from "./toggleRate"
import * as bootstrap from "bootstrap"

const transactions_query = `[data-app=transactions-new]`
const el = document.querySelector(transactions_query)

if (el) {
  toggleRate(el)
}
