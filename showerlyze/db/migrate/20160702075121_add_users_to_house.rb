class AddUsersToHouse < ActiveRecord::Migration
  def change
    add_reference :users, :house, index: true, foreign_key: true
  end
end
