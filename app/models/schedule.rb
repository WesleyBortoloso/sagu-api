class Schedule < ApplicationRecord
  belongs_to :parent, class_name: 'Parent'
  belongs_to :student, class_name: 'Student'
  belongs_to :relator, class_name: 'User'

  enum :area, {
    academic: 0,
    administrative: 1,
    pedagogic: 2
  }

  enum :status, {
    waiting: 0,
    confirmed: 1,
    rejected: 2
  }

  validates :date, :subject, :area, :status, presence: true
end
