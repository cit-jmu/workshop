class MoveDurationFromCourseToPart < ActiveRecord::Migration
  def change
    remove_column :courses, :duration, :integer
    add_column :parts, :duration, :integer
  end
end
