class CreateConditionsStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :conditions_students, id: false do |t|
      t.uuid :student_id, null: false
      t.uuid :condition_id, null: false

      t.index [:student_id, :condition_id], unique: true
    end

    add_foreign_key :conditions_students, :users, column: :student_id
    add_foreign_key :conditions_students, :conditions
  end
end