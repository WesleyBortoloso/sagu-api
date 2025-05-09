class MakeParentIdNullableOnOrientations < ActiveRecord::Migration[7.1]
  def change
    change_column_null :orientations, :parent_id, true
  end
end
