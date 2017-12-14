class Dish < ApplicationRecord
  before_create :set_slug

  belongs_to :user
  has_many :orders
  has_many :dishes
  has_and_belongs_to_many :tags

  mount_uploader :cover, DishImageUploader

  validates :name, presence: true, length: { minimum: 5 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :ingredients, presence: true, length: { minimum: 5 }
  validates :portions, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  # TODO: Implement date validation
  validates :delivery_at, presence: true
  
  def to_param
    slug
  end

  private
  def set_slug
    loop do
      self.slug = self.name.parameterize + '-' + SecureRandom.uuid[1..8]
      break unless Dish.where(slug: slug).exists?
    end
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
                JOIN dishes_tags 
                ON dishes.id = dishes_tags.dish_id AND dishes_tags.tag_id IN (#{tags_id.join(",")})
                GROUP BY dishes.id
                HAVING COUNT(DISTINCT dishes_tags.tag_id) =  #{count_id}" )
  end

end
