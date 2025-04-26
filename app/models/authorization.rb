class Authorization < ApplicationRecord
  belongs_to :student, class_name: 'Student'
  belongs_to :parent, class_name: 'Parent'

  enum :status, {
    pending: 'Pendente',
    approved: 'Aprovada',
    denied: 'Recusada'
  }

  validates :date, :description, :status, presence: true
end
