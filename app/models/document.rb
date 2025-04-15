class Document < ApplicationRecord
  belongs_to :student
  has_one_attached :file

  validates :name, :kind, presence: true
end
