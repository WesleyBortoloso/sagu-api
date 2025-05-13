class AddPrivateToOccurrencies < ActiveRecord::Migration[7.1]
  def change
    add_column :occurrencies, :private, :boolean, default: false, null: false
  end
end
