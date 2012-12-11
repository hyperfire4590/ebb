class CreatePaymentDetails < ActiveRecord::Migration
  def change
    create_table :payment_details do |t|
      t.integer :user_id
      t.decimal :amount
      t.integer :payable_id
      t.string :payable_type

      t.timestamps
    end
  end
end
