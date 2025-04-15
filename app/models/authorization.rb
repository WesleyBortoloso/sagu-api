class Authorization < ApplicationRecord
  belongs_to :student, class_name: 'Student'
  belongs_to :parent, class_name: 'Parent'

  enum :status, {
    pending: 0,
    approved: 1,
    denied: 2
  }

  validates :date, :description, :status, presence: true
end
