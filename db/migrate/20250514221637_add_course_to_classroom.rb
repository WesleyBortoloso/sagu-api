class AddCourseToClassroom < ActiveRecord::Migration[7.1]
  def change
    add_column :classrooms, :course, :string
  end
end
