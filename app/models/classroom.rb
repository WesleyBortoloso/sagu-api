class Classroom < ApplicationRecord
  has_many :students, class_name: 'Student', dependent: :nullify
  has_many :classrooms_teachers, dependent: :destroy
  has_many :teachers, through: :classrooms_teachers, source: :teacher

  validates :name, :grade, :year, :course, presence: true
end
