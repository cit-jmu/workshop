class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.integer :section_id
      t.string :location
      t.datetime :starts_at
      t.integer :instructor_id

      t.timestamps
    end
  end
end
