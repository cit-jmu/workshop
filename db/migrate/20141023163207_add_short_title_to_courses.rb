class AddShortTitleToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :short_title, :string, limit: 30
  end
end
