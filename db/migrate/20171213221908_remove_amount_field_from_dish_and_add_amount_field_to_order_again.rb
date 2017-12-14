class RemoveAmountFieldFromDishAndAddAmountFieldToOrderAgain < ActiveRecord::Migration[5.1]
  def change
    remove_column :dishes, :amount
    add_column :orders, :amount, :integer
  end
end
