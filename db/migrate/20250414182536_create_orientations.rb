class CreateOrientations < ActiveRecord::Migration[7.1]
  def change
    create_table :orientations, id: :uuid do |t|
      t.string :title
      t.string :description
      t.string :area
      t.string :status
      t.uuid :student_id, null: false
      t.uuid :parent_id, null: false
      t.uuid :relator_id, null: false
      t.uuid :responsible_id, null: false

      t.timestamps
    end

    add_foreign_key :orientations, :users, column: :student_id
    add_foreign_key :orientations, :users, column: :parent_id
    add_foreign_key :orientations, :users, column: :relator_id
    add_foreign_key :orientations, :users, column: :responsible_id
  end
end
