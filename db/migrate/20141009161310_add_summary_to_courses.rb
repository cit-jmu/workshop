class AddSummaryToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :summary, :string
  end
end
