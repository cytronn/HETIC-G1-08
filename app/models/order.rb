class Order < ApplicationRecord
  belongs_to :dish
  before_create :set_expiration_time
  enum status: [ :pending, :paid, :aborted ]

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
