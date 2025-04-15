class Orientation < ApplicationRecord
  belongs_to :student, class_name: 'Student', inverse_of: :occurrencies
  belongs_to :parent, class_name: 'Parent'
  belongs_to :relator, class_name: 'User'
  belongs_to :responsible, class_name: 'User'
  has_many :events, as: :eventable, dependent: :destroy

  validate :valid_relator_responsible

  def valid_relator_responsible
    allowed = %w[Teacher Staff]
    errors.add(:relator, 'invalid type') unless relator.type.in?(allowed)
    errors.add(:responsible, 'invalid type') unless responsible.type.in?(allowed)
  end
end
