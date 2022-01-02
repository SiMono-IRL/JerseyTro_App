class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.datetime :order_date
      t.references :user, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
