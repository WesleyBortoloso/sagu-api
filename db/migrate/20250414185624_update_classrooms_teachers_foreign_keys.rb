class UpdateClassroomsTeachersForeignKeys < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :classrooms_teachers, :classrooms
    remove_foreign_key :classrooms_teachers, column: :teacher_id

    add_foreign_key :classrooms_teachers, :classrooms, on_delete: :cascade
    add_foreign_key :classrooms_teachers, :users, column: :teacher_id, on_delete: :cascade
  end
end
