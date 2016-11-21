class AddOverallTempToShowers < ActiveRecord::Migration
  def change
    add_column :showers, :overall_temp, :float
  end
end
