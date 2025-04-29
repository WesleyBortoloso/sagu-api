class Document < ApplicationRecord
  belongs_to :student, class_name: 'User', foreign_key: :student_id
  has_one_attached :file

  validates :name, :kind, presence: true
end
