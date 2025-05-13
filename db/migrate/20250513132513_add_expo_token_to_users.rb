class AddExpoTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :expo_token, :string
  end
end
