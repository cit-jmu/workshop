class AddNoShowToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :no_show, :boolean, default: false
  end
end
