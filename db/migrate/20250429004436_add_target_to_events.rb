class AddTargetToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :target_type, :string
    add_column :events, :target_id, :uuid
  end
end
