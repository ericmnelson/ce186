class RemoveCurrentShowerFromBathroom < ActiveRecord::Migration
  def change
    remove_reference :bathrooms, :shower, index: true, foreign_key: true
  end
end
