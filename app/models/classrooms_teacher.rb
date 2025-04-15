class ClassroomsTeacher < ApplicationRecord
  self.table_name = 'classrooms_teachers'

  belongs_to :classroom
  belongs_to :teacher, class_name: 'Teacher'
end
