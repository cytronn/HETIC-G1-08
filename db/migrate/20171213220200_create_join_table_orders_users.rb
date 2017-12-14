class CreateJoinTableOrdersUsers < ActiveRecord::Migration[5.1]
  def change
    create_join_table :orders, :users do |t|
      # t.index [:tag_id, :dish_id]
      # t.index [:dish_id, :tag_id]
    end    
  end
end
