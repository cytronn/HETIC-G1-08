class AddOrganizationToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :organization, index: true    
  end
end
