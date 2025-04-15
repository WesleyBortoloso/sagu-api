class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.string :name
      t.string :kind
      t.references :student, null: false, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end
  end
end
