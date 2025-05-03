class Authorization < ApplicationRecord
  belongs_to :student, class_name: 'Student'
  belongs_to :parent, class_name: 'Parent'

  enum :status, {
    pending: 'pending',
    approved: 'approved',
    refused: 'refused'
  }

  validates :date, :description, :status, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[date status student_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[student]
  end
end
