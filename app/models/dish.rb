class Dish < ApplicationRecord
  belongs_to :user
  has_many :orders
  has_and_belongs_to_many :tags

  attr_accessor :description, :title
  mount_uploader :cover, DishImageUploader

  validates :name, presence: true, length: { minimum: 5 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :ingredients, presence: true, length: { minimum: 5 }
  validates :portions, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  
  # TODO: Implement date validation
  # validates :delivery_at, presence: true

  scope :tagged_with, ->(tags_id, tags_lgth) { joins("JOIN dishes_tags 
  ON dishes.id = dishes_tags.dish_id AND dishes_tags.tag_id IN (#{tags_id.join(",")})
  GROUP BY dishes.id
  HAVING COUNT(DISTINCT dishes_tags.tag_id) =  #{tags_lgth}") }
  

  def self.filter(organization = nil, tags)
    tags = tags.split(',');
    tags_id = [];
    
    if tags[0] != 'all'
      tags.map do |tag|
        curr_tag = Tag.find_by!(name: tag)
        tags_id.push(curr_tag.id)
      end

      count_id = tags_id.count

      Dish.tagged_with(tags_id, count_id)
      
    else
      Dish.all
    end
  end

end