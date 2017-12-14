class AddSlugFieldToDish < ActiveRecord::Migration[5.1]
  def change
    add_column :dishes, :slug, :string
    add_index :dishes, :slug, unique: true
  end
end
