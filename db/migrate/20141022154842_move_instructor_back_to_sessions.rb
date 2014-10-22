class MoveInstructorBackToSessions < ActiveRecord::Migration
  def change
    remove_column :parts, :instructor_id, :integer
    add_column :sections, :instructor_id, :integer
  end
end
