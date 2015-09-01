class AddEvaluationUrlToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :evaluation_url, :string
  end
end
