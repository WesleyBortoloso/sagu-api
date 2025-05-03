class Condition < ApplicationRecord
  enum category: {
    scholarship: 'scholarship',
    special_need: 'special_need'
  }

  has_and_belongs_to_many :students,
                          class_name: 'Student',
                          join_table: 'conditions_students'

  validates :name, presence: true
  validates :category, presence: true, inclusion: { in: categories.keys }
  validates :name, uniqueness: { scope: :category }
end