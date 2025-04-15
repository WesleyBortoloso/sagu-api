class CreateClassrooms < ActiveRecord::Migration[7.1]
  def change
    create_table :classrooms, id: :uuid do |t|
      t.string :name
      t.string :grade
      t.date :year
      t.integer :external_id

      t.timestamps
    end
  end
end
