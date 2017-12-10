class Order < ApplicationRecord
  before_create :set_slug
  before_create :set_name

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

  validates :status, presence: true, :inclusion=> { :in => ['pending', 'paid'] }
end
