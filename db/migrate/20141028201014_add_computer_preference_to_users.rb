class AddComputerPreferenceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :computer_preference, :string, limit: 8
  end
end
