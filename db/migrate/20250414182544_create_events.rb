class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events, id: :uuid do |t|
      t.string :description, null: false
      t.uuid :eventable_id, null: false
      t.string :eventable_type, null: false
      t.uuid :author_id, null: false
      t.string :author_type, null: false
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :events, [:eventable_type, :eventable_id]
    add_index :events, [:author_type, :author_id]
  end
end
