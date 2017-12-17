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
  validates :portions, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, on: :create
  :portions_left
  # TODO: Implement date validation
  # validates :delivery_at, presence: true

  scope :in_organization, ->(id) {
    joins(:user).where(users: { organization_id: id })
  }

  scope :tagged_with, ->(tags_id) {
    if tags_id[0] != "all"
      joins(:dishes_tags).where(:dishes_tags => { :tag_id => tags_id }).group("dishes.id").having('count(dishes_tags.tag_id)= ?', tags_id.count).distinct(true)      
    else
      Dish.all
    end
  }

  scope :delivery_today, -> { where(delivery_at: date.today.strftime("%m-%d-%Y")) }

  scope :delivery_tomorrow, -> { where(delivery_at: date.tomorrow.strftime("%m-%d-%Y")) }
  
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

  private
  def self.filter(tags, date)
    tags_id = [];
    if tags = 'all' do
      tags_id.push('all')      
    else
      tags.split(',').map do |tag|
        curr_tag = Tag.find_by!(name: tag)
        tags_id.push(curr_tag.id)
      end
    end
    Dish.tagged_with(tags_id)
  end
    
end

