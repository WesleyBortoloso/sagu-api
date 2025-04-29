class RecreateDocumentsWithUuid < ActiveRecord::Migration[7.1]
  def change
    drop_table :documents

    create_table :documents, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :name
      t.string :kind
      t.references :student, null: false, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end
  end
end
