class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, limit: 8, null: false
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :employee_id, limit: 10
      t.string :phone, limit: 25
      t.string :mailbox
      t.string :department
      t.string :affiliation, limit: 20
      t.string :nickname
      t.string :computer_preference, limit: 20

      t.timestamps
    end
  end
end
