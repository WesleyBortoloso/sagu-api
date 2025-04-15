class CreateAuthorizations < ActiveRecord::Migration[7.1]
  def change
    create_table :authorizations, id: :uuid do |t|
      t.date :date
      t.string :description
      t.string :status
      t.uuid :student_id, null: false
      t.uuid :parent_id, null: false

      t.timestamps
    end

    add_foreign_key :authorizations, :users, column: :student_id
    add_foreign_key :authorizations, :users, column: :parent_id
  end
end
