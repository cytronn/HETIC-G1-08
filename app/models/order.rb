class Order < ApplicationRecord
  before_create :set_slug
  before_create :set_name
  before_create :set_expiration_time

  belongs_to :dish
  belongs_to :user

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  enum statuses: [:pending, :paid, :aborted]

  def to_param
    slug
  end

  private
  def set_name
    if Order.last
      self.name = Integer(Order.last.name) + 1
    else 
      self.name = 1
    end
  end
  
  private
  def set_slug
    loop do
      self.slug = SecureRandom.uuid
      break unless Order.where(slug: slug).exists?
    end
  end

  scope :awaiting_payment, -> {
    where(status: :pending)
  }

  scope :paid, -> {
    where(status: :paid)
  }

  def set_expiration_time
    self.expire_at = Time.now + 15.minutes
  end
end
