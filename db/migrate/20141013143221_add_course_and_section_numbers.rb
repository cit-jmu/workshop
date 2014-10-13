class AddCourseAndSectionNumbers < ActiveRecord::Migration
  def change
    add_column :courses, :course_number, :string, limit: 8
    add_column :sections, :section_number, :string, limit: 6
  end
end
