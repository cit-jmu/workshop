class AddWaitingToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :waiting, :boolean, default: false
  end
end
