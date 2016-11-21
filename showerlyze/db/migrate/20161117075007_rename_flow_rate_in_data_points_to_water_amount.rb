class RenameFlowRateInDataPointsToWaterAmount < ActiveRecord::Migration
  def change
    rename_column :data_points, :flow_rate, :water_amount
  end
end
