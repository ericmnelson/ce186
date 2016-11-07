class AddUserToShower < ActiveRecord::Migration
  def change
    add_reference :showers, :user, index: true, foreign_key: true
  end
end
