class AddCurrentShowerToBathroom < ActiveRecord::Migration
  def change
    add_reference :bathrooms, :shower, index: true, foreign_key: true
  end
end
