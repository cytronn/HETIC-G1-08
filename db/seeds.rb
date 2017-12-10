AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development? && AdminUser.count == 0
Tag.create(name: "Tag #1")
Tag.create(name: "Tag #2")