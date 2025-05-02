class Occurrency < ApplicationRecord
  belongs_to :student, class_name: 'Student', inverse_of: :occurrencies
  belongs_to :relator, class_name: 'User'
  belongs_to :responsible, class_name: 'User'
  has_many :events, as: :eventable, dependent: :destroy

  enum :kind, {
    health: 'health',
    discipline: 'discipline',
    administrative: 'administrative',
    other: 'other'
  }

  enum :severity, {
    normal: 'normal',
    medium: 'medium',
    high: 'high'
  }

  enum :status, {
    open: 'open',
    in_progress: 'in_progress',
    resolved: 'resolved',
    closed: 'closed'
  }

  validate :valid_relator_responsible

  def valid_relator_responsible
    allowed = %w[Teacher Staff]
    errors.add(:relator, 'invalid type') unless relator.type.in?(allowed)
    errors.add(:responsible, 'invalid type') unless responsible.type.in?(allowed)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[kind area status student_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[student]
  end
end
