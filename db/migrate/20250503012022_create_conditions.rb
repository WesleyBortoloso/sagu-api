class CreateConditions < ActiveRecord::Migration[7.1]
  def change
    create_table :conditions, id: :uuid do |t|
      t.string :name, null: false 
      t.string :category, null: false
      t.text :description
      t.timestamps
    end    
  end
end
