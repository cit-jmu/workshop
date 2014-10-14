class AddUuidToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :ical_event_uid, :uuid
  end
end
