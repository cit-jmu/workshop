class AddInstituteToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :institute, :boolean, default: false
  end
end
