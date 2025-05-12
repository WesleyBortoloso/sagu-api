class Orientation < ApplicationRecord
  belongs_to :student, class_name: 'Student', inverse_of: :occurrencies
  belongs_to :parent, class_name: 'Parent', optional: true
  belongs_to :relator, class_name: 'User'
  belongs_to :responsible, class_name: 'User'
  has_many :events, as: :eventable, dependent: :destroy

  enum :status, {
    open: 'open',
    in_progress: 'in_progress',
    resolved: 'resolved',
    closed: 'closed'
  }

  enum :area, {
    academic: 'academic',
    administrative: 'administrative',
    pedagogic: 'pedagogic',
    health: 'health'
  }

  validate :valid_relator_responsible

  def valid_relator_responsible
    allowed = %w[Teacher Staff]
    errors.add(:relator, 'invalid type') unless relator.type.in?(allowed)
    errors.add(:responsible, 'invalid type') unless responsible.type.in?(allowed)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[area status student_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[student]
  end
end
