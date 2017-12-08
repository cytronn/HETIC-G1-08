class Dish < ApplicationRecord
  belongs_to :user
  has_many :orders

  validates :name, presence: true, length: { minimum: 5 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :ingredients, presence: true, length: { minimum: 5 }
  validates :portions, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, on: :create
  :portions_left
  # TODO: Implement date validation
  # validates :delivery_at, presence: true
end
