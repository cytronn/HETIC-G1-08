json.extract! order, :id, :name, :user_id, :note, :quantity, :created_at, :updated_at
json.url order_url(order, format: :json)
