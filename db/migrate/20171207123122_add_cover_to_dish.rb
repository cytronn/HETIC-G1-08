class AddCoverToDish < ActiveRecord::Migration[5.1]
  def change
    add_column :dishes, :cover, :string
  end
end
