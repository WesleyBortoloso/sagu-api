class CreateJoinTableClassroomsTeachers < ActiveRecord::Migration[7.1]
  def change
    create_table :classrooms_teachers, id: false do |t|
      t.uuid :classroom_id, null: false
      t.uuid :teacher_id, null: false
    end

    add_index :classrooms_teachers, %i[classroom_id teacher_id], unique: true
    add_foreign_key :classrooms_teachers, :classrooms
    add_foreign_key :classrooms_teachers, :users, column: :teacher_id
  end
end
