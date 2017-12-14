class AddAmountFieldToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :dishes, :amount, :integer
  end
end
