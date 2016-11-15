class AddPreferredTemperatureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :preferred_temp, :float
  end
end
