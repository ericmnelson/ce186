class CreateTemperatures < ActiveRecord::Migration
  def change
    create_table :temperatures do |t|
      t.references :shower, index: true, foreign_key: true
      t.float :temp
      t.datetime :time

      t.timestamps null: false
    end
  end
end
