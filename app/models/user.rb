class User < ApplicationRecord
  belongs_to :organization
  has_many :dishes
  has_many :orders

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  validates :first_name, presence: true, length: { maximum: 65 }
  validates :last_name, presence: true, length: { maximum: 65 }
  validates :organization_id, presence: true
end
