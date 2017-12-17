class AddPriceFieldsToDatabase < ActiveRecord::Migration[5.1]
  def change
    change_column :dishes, :price, :decimal, :precision => 8, :scale => 2
    change_column :orders, :amount, :decimal, :precision => 8, :scale => 2
  end
end
