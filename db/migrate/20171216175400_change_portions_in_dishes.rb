class ChangePortionsInDishes < ActiveRecord::Migration[5.1]
  def change
    change_column :dishes, :portions, 'integer USING CAST(portions AS integer)'
  end
end
