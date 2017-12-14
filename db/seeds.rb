AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development? && AdminUser.count == 0
# Tag.create!(name: 'veggie')
# Tag.create!(name: 'gluten-free')
# Tag.create!(name: 'spicy')
# Tag.create!(name: 'light')