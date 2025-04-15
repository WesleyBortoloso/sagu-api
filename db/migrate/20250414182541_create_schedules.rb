class CreateSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :schedules, id: :uuid do |t|
      t.datetime :starts_at, null: false
      t.string :subject
      t.string :area
      t.string :status
      t.uuid :parent_id, null: false
      t.uuid :relator_id, null: false
      t.uuid :student_id, null: false

      t.timestamps
    end

    add_foreign_key :schedules, :users, column: :parent_id
    add_foreign_key :schedules, :users, column: :relator_id
    add_foreign_key :schedules, :users, column: :student_id
  end
end
