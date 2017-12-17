class Dish < ApplicationRecord
  before_create :set_slug

  belongs_to :user
  has_many :orders
  has_many :dishes
  has_and_belongs_to_many :tags

  mount_uploader :cover, DishImageUploader

  validates :name,presence: true, length: { minimum: 5 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :ingredients, presence: true, length: { minimum: 5 }
  validates :portions, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, on: :create
  # TODO: Implement date validation
  # validates :delivery_at, presence: true

  scope :in_organization, lambda { |id|
    joins(:user).where(users: { organization_id: id })
  }

  scope :tagged_with, lambda { |tags|
    if tags != nil
      tags_id = tags.split('/').map do |tag|
        Tag.find_by!(slug: tag).id
      end
      joins(:dishes_tags).where(:dishes_tags => { :tag_id => tags_id }).group("dishes.id").having('count(dishes_tags.tag_id)= ?', tags_id.count).distinct(true)
    end
  }
  
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
end
