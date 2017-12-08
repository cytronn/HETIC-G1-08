class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :name
      t.integer :user_id
      t.string :note
      t.integer :quantity

      t.timestamps
    end
  end
end
