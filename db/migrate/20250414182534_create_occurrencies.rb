class CreateOccurrencies < ActiveRecord::Migration[7.1]
  def change
    create_table :occurrencies, id: :uuid do |t|
      t.string :title, null: false
      t.string :description
      t.string :kind, null: false
      t.string :severity, null: false
      t.string :status
      t.string :priority
      t.uuid :student_id, null: false
      t.uuid :relator_id, null: false
      t.uuid :responsible_id, null: false

      t.timestamps
    end

    add_foreign_key :occurrencies, :users, column: :student_id
    add_foreign_key :occurrencies, :users, column: :relator_id
    add_foreign_key :occurrencies, :users, column: :responsible_id
  end
end
