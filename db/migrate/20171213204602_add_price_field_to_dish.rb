class AddPriceFieldToDish < ActiveRecord::Migration[5.1]
  def change
    add_column :dishes, :price, :integer
  end
end
