class LinkOrderToDish < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :dish, index: true
  end
end
