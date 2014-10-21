class DropInstructorIdAndLocationAndStartsAtFromSectins < ActiveRecord::Migration
  def change
    change_table :sections do |t|
      t.remove :instructor_id, :location, :starts_at
    end
  end
end
