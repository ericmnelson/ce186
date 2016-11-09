class CreateDataPoints < ActiveRecord::Migration
  def change
    create_table :data_points do |t|
      t.references :shower, index: true, foreign_key: true
      t.float :flow_rate
      t.float :temp
      t.datetime :time

      t.timestamps null: false
    end
  end
end
