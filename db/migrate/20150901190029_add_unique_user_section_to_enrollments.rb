class AddUniqueUserSectionToEnrollments < ActiveRecord::Migration
  def change
    add_index :enrollments, [:section_id, :user_id], unique: true
  end
end
