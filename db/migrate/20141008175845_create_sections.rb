class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :location
      t.integer :seats
      t.datetime :starts_at
      t.integer :course_id

      t.timestamps
    end
  end
end
