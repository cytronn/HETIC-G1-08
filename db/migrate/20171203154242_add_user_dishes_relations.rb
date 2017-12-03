class AddUserDishesRelations < ActiveRecord::Migration[5.1]
  def change
    add_reference :dishes, :user, index: true
  end
end
