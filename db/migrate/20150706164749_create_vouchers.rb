class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.integer :customer_id
      t.integer :company_id
      t.decimal :amount, :precision => 8, :scale => 2
      t.string :currency
      t.string :number
      t.string :status
    end
  end
end
