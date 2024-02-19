class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string "email", null: false
      t.string "txid"
      t.string "address", null: false
      t.string "base"
      t.string "target"
      t.decimal "amount_base", null: false
      t.decimal "amount_target", null: false
      t.decimal "exchange_fee", null: false
      t.decimal "exchange_rate", null: false
      t.integer "status"
      t.timestamps
    end

    add_index :transactions, :txid, unique: true
  end
end
