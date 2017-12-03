class AddNewFieldsToDishes < ActiveRecord::Migration[5.1]
  def change
    add_column :dishes, :ingredients, :string
    add_column :dishes, :delivery_at, :date
  end
end
