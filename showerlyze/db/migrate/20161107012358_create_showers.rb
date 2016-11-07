class CreateShowers < ActiveRecord::Migration
  def change
    create_table :showers do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :bathroom, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
