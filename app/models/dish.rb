class Dish < ApplicationRecord
  has_many :taggings
  has_many :tags, through: :taggings

  validates :name, presence: true, length: { minimum: 5 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :ingredients, presence: true, length: { minimum: 10 }
  validates :portions, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  # validates :delivery_at, presence: true

  def all_tags=(names)
    self.tags = names.map do |name|
        Tag.where(name: name).first_or_create!
    end
  end

  def all_tags
    self.tags.map(&:name).join(", ")
  end

  def self.tagged_with(names)
    tags_id = [];
    params = names.split(',');
    params.map do |param|
      curr_tag = Tag.find_by!(name: param)
      tags_id.push(curr_tag.id)
    end
    count_id = tags_id.count
    find_by_sql("SELECT dishes.id, dishes.name, dishes.description, dishes.portions, dishes.ingredients, dishes.delivery_at
                FROM dishes
                JOIN taggings 
                ON dishes.id = taggings.dish_id AND taggings.tag_id IN (#{tags_id.join(",")})
                GROUP BY dishes.id
                HAVING COUNT(DISTINCT taggings.tag_id) =  #{count_id}" )
  end

end
