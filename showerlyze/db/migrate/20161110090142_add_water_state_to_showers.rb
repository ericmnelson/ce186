class AddWaterStateToShowers < ActiveRecord::Migration
  def change
    add_column :showers, :shower_on, :boolean
    add_column :showers, :temp_ready, :boolean
  end
end
