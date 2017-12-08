class Tag < ApplicationRecord
    has_many :taggings
    has_many :dishes, through: :taggings
end
