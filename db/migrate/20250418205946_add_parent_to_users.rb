class AddParentToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :parent, foreign_key: { to_table: :users }, type: :uuid
  end
end
