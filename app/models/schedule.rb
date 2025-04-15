class Schedule < ApplicationRecord
  belongs_to :parent, class_name: 'Parent'
  belongs_to :student, class_name: 'Student'
  belongs_to :relator, class_name: 'User'

  enum :area, { academic: 'academic', administrative: 'administrative' }
  enum :status, { open: 'open', completed: 'completed', canceled: 'canceled' }

  validates :date, :subject, :area, :status, presence: true
end
