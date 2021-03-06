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
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 1 }, on: :create
  validates :delivery_at, presence: true
  validate :delivery_at_must_be_in_future

  :portions_left
  # TODO: Implement date validation

  scope :in_organization, lambda { |id|
    joins(:user).where(users: { organization_id: id })
  }

  scope :tagged_with, lambda { |tags|
    if tags != 'all' and tags != nil
      tags_id = tags.split('/').map do |tag|
        Tag.find_by!(slug: tag).id
      end
      joins(:dishes_tags).where(:dishes_tags => { :tag_id => tags_id }).group("dishes.id").having('count(dishes_tags.tag_id)= ?', tags_id.count).distinct(true)
    end
  }

  scope :delivery_day, lambda { |day|
    if day != 'all' and day != nil
      if day == 'today'
        where(delivery_at: Time.now.strftime("%d-%m-%Y"))      
      elsif day == 'tomorrow' 
        where(delivery_at: Time.now.tomorrow.to_date.strftime("%d-%m-%Y"))      
      elsif day == 'week'
        where(delivery_at: Date.today..Date.today + 7.days)
      end
    end
  }

  def to_param
    slug
  end

  private
  def set_slug
    loop do
      self.slug = self.name.parameterize + '-' + SecureRandom.uuid[1..7]
      break unless Dish.where(slug: slug).exists?
    end
  end
  
  def delivery_at_must_be_in_future
    if delivery_at && delivery_at < Time.now.beginning_of_day
      self.errors.add(:delivery_at, "The delivery date has to be set in the future!")
    end
  end
end
