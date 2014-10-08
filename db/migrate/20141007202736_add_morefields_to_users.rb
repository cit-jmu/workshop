class AddMorefieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone_number, :string
    add_column :users, :department, :string
    add_column :users, :mailbox, :string
    add_column :users, :nickname, :string
  end
end
