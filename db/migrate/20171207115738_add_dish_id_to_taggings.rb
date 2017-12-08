class AddDishIdToTaggings < ActiveRecord::Migration[5.1]
  def change
    add_column :taggings, :dish_id, :integer
  end
end
