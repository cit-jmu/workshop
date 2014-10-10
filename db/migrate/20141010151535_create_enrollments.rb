class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.integer :section_id
      t.integer :user_id
      t.datetime :completed_at

      t.timestamps
    end
  end
end
