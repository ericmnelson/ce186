class AddPasscodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :passcode, :string
  end
end
