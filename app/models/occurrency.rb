class Occurrency < ApplicationRecord
  belongs_to :student, class_name: 'Student', inverse_of: :occurrencies
  belongs_to :relator, class_name: 'User'
  belongs_to :responsible, class_name: 'User'
  has_many :events, as: :eventable, dependent: :destroy

  enum :kind, {
    behavior: 0,
    discipline: 1,
    delay: 2,
    absence: 3,
    academic: 4,
    administrative: 5,
    other: 99
  }

  enum :severity, {
    normal: 0,
    medium: 1,
    high: 2,
    critical: 3
  }

  enum :status, {
    open: 0,
    in_progress: 1,
    resolved: 2,
    closed: 3,
    canceled: 4
  }

  validate :valid_relator_responsible

  def valid_relator_responsible
    allowed = %w[Teacher Staff]
    errors.add(:relator, 'invalid type') unless relator.type.in?(allowed)
    errors.add(:responsible, 'invalid type') unless responsible.type.in?(allowed)
  end
end
