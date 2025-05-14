class CreateAnnouncements < ActiveRecord::Migration[7.1]
  def change
    create_table :announcements, id: :uuid do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.date :date, null: false

      t.timestamps
    end
  end
end